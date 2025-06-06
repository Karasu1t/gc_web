## フェーズ 4： GithubActions での CI 環境構築

### 概要

イメージに更新があった場合に、GithubActions により自動でビルドし、ArtifactRegistry に Push する構成および、  
上記発動後に ArgoCD にて Deployment で管理する Pod を再デプロしなおす構成を構築する

---

### 手順

#### 1. Terraform 用の tf ファイル群を作成

#### 2. Github に Secret/Variables の設定追加

#### 3. Github 上に workflow を作成

#### 4. Github 上の src をアップデートし、ArtifactRegistry 上のイメージが更新されることのテスト

#### 5. Deployment で管理する Pod が再デプロイされることの確認
