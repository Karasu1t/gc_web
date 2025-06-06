## フェーズ 4： GithubActions での CI 環境構築

### 概要

イメージに更新があった場合に、GithubActions により自動でビルドし、ArtifactRegistry に Push する  
また併せて deploy-web.yaml の Image の箇所を更新し、ArgoCD にて Deployment で管理する Pod を再デプロイしなおす CI/CD 環境を構築する

---

### 手順

#### 1. Github の Secret 追加

gc_web レポジトリ配下の Secret に以下を設定する

<pre><code>
GCP_CREDENTIALS: keys.jsonのファイル内容
PROJECT_ID: プロジェクト名
REGION: asia-northeast1
REPO_NAME: ArtifactRegistryのレポジトリ名
IMAGE_NAME: my-app
</code></pre>

![クラスタ画面](picture/Phase3-4-1.png)

#### 2. GithubActions 用の Workflow 用ファイルを作成する

<pre><code>
.
├── .github(NEW)
│ └── workflows
│ └── deploy-image.yaml
└── src
├── Dockerfile
└── app.py
</code></pre>

◆deploy-image.yaml

<pre><code>
name: GKE CI/CD Pipeline

permissions:
  contents: write

on:
  push:
    paths:
      - "src/**"
      - ".github/workflows/**"
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    env:
      PROJECT_ID: ${{ secrets.PROJECT_ID }}
      REGION: ${{ secrets.REGION }}
      REPO_NAME: ${{ secrets.REPO_NAME }}
      IMAGE_NAME: ${{ secrets.IMAGE_NAME }}

    steps:
      - name: Echo test
        run: echo "${{ env.REGION }}"

      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Docker auth for GCP
        uses: google-github-actions/auth@v2
        with:
          credentials_json: ${{ secrets.GCP_CREDENTIALS }}

      - name: Configure Docker for Artifact Registry
        run: |
          gcloud auth configure-docker ${{ env.REGION }}-docker.pkg.dev

      - name: Set image tag
        run: echo "IMAGE_TAG=$(date +%Y%m%d%H%M%S)" >> $GITHUB_ENV

      - name: Build Docker image
        run: |
          docker build -t ${{ env.REGION }}-docker.pkg.dev/${{ env.PROJECT_ID }}/${{ env.REPO_NAME }}/${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }} ./src

      - name: Push image
        run: |
          docker push ${{ env.REGION }}-docker.pkg.dev/${{ env.PROJECT_ID }}/${{ env.REPO_NAME }}/${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }}

      - name: Update deploy-web.yaml with new image tag
        run: |
          IMAGE_URI="${{ env.REGION }}-docker.pkg.dev/${{ env.PROJECT_ID }}/${{ env.REPO_NAME }}/${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }}"
          sed -i "s|image: .*|image: $IMAGE_URI|" ./manifest/project/deploy-web.yaml

      - name: Commit and push manifest
        run: |
          git config user.name "github-actions"
          git config user.email "github-actions@users.noreply.github.com"

          git add ./manifest/project/deploy-web.yaml

          if git diff --cached --quiet; then
            echo "No changes to commit"
          else
            git commit -m "Update image to latest"
            git push
          fi
</code></pre>

◆src/app.py

styele を追加(後続のテスト用)

<pre><code>
    return f"""
    <html>
    <head>
    <style>
        body {{
        background-color: blue;
        font-family: Arial, sans-serif;
        padding: 20px;
        }}
        pre {{
        background-color: #f0f0f0;
        padding: 10px;
        border-radius: 5px;
        overflow-x: auto;
        }}
    </style>

    </head>
    <body>
        <h1>Service Account Token:</h1><pre>{sa_token[:100]}...</pre>
        <h1>ConfigMap Value:</h1><p>{config_value}</p>
        <h1>Hostname:</h1><p>{hostname}</p>
    </body>
    </html>
    """

</code></pre>

#### 3. Build+Push、deploy-web.yaml 更新のテスト

github にプッシュする

Action が正常終了していることを確認する
