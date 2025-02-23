# プロジェクト構成

このプロジェクトは、クリーンアーキテクチャの原則に従って構成されています。

## フォルダ構造 
lib/
├── features/
│ └── todo/
│ ├── data/
│ │ ├── datasources/
│ │ │ ├── local_todo_data_source.dart
│ │ │ └── local_category_data_source.dart
│ │ ├── models/
│ │ │ └── todo_dto.dart
│ │ ├── todo_repository.dart
│ │ └── category_repository.dart
│ │
│ ├── domain/
│ │ ├── models/
│ │ │ ├── todo.dart
│ │ │ └── category.dart
│ │ ├── use_cases/
│ │ │ ├── get_todos_use_case.dart
│ │ │ └── search_todos_use_case.dart
│ │ └── errors/
│ │ └── todo_errors.dart
│ │
│ └── presentation/
│ ├── controllers/
│ │ └── todo_controller.dart
│ ├── providers/
│ │ └── todo_providers.dart
│ ├── screens/
│ │ ├── todo_list_screen.dart
│ │ └── category_list_screen.dart
│ └── widgets/
│ └── todo_list_item.dart

## レイヤー説明

### データ層 (Data Layer)
- データの永続化と取得を担当
- `local_todo_data_source.dart`: SharedPreferencesを使用したToDoデータの永続化
- `local_category_data_source.dart`: カテゴリデータの永続化
- `todo_repository.dart`: ToDoのリポジトリ実装
- `category_repository.dart`: カテゴリのリポジトリ実装

### ドメイン層 (Domain Layer)
- ビジネスロジックを含むコアレイヤー
- `todo.dart`: ToDoエンティティ
- `category.dart`: カテゴリエンティティ
- `get_todos_use_case.dart`: ToDo一覧取得のユースケース
- `search_todos_use_case.dart`: ToDo検索のユースケース
- `todo_errors.dart`: エラー定義

### プレゼンテーション層 (Presentation Layer)
- UIとユーザーインタラクションを管理
- `todo_controller.dart`: ToDo関連の状態管理
- `todo_providers.dart`: Riverpodプロバイダー
- `todo_list_screen.dart`: ToDo一覧画面
- `category_list_screen.dart`: カテゴリ管理画面
- `todo_list_item.dart`: ToDo項目のUI

## 主要な機能

1. ToDo管理
   - ToDo項目の追加/編集/削除
   - 完了状態の切り替え
   - 優先度設定
   - 期限日設定
   - カテゴリ割り当て

2. カテゴリ管理
   - カテゴリの追加/編集/削除
   - カラー設定
   - ToDoとの関連付け

## 使用している主要パッケージ

- `flutter_riverpod`: ^2.6.1 (状態管理)
- `shared_preferences`: ^2.2.2 (ローカルストレージ)
- `mockito`: ^5.4.4 (テスト用)