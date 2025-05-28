## 概要

GKE(Google Cloud)上にクラスタを作成し、その中でコンテナを起動して web サーバを外部公開する  
また、上記環境を terraform を使用して構築し IaC 化し、ArgoCD と GithubActions を使用した CI/CD 環境を構築する

## 目的

- GoogleCloud 上で、以前学習した Kubernetes のコンテナを稼働出来るようにする
- GoogleCloud 環境を Terraform を使用して出来るようになる
- コンテナの CI/CD 環境を構築し、GitOps としてイメージ更新時に自動でコンテナに反映できるようにする

## アーキテクチャ図

※後で挿入予定

## 前提条件

- GitHub 上に以下のリポジトリを作成しておく：
- [gc-web](https://github.com/Karasu1t/gc_web)
- GoogleCloud アカウントを作成し、予め必要な API の有効化および terraform のための ServiceAccount を作成している

## フェーズ構成

本環境構築は以下のフェーズに分けて進める：

1. **GKE 上でコンテナを稼働できること**
2. **コンテナイメージを自前で作成し、Artifact Registry 上から pull してコンテナを起動できること**
3. **Argo CD から自動デプロイができること**
4. **イメージに更新があったときに、GithubActions を使用して、Artifact Registry 上のイメージを更新できること**

---

各フェーズの詳細手順や設定内容については、以降のセクションに記載。

[Phase 1 - GKE 上でコンテナを稼働させる](https://github.com/Karasu1t/gc_web/blob/main/Phase1.md)  
[Phase 2 - コンテナイメージ準備+Artifact Registry からのイメージ取得](https://github.com/Karasu1t/gc_web/blob/main/Phase2.md)  
[Phase 3 - ArgoCD の自動デプロイ](https://github.com/Karasu1t/gc_web/blob/main/Phase3.md)  
[Phase 4 - GithubActions での CI 環境構築](https://github.com/Karasu1t/gc_web/blob/main/Phase4.md)
