# NovaNUR

**NovaNUR** — raitpor 自用的 Nix 包集合。以独立 flake 管理，收录的
是不在 nixpkgs 上游、需要额外补丁、或者自己维护更顺手的包。

## 当前包

| 名称 | 说明 |
|------|------|
| `reasonix-desktop` | DeepSeek 推理模型桌面客户端（GTK3/WebKit2GTK） |

### reasonix-desktop

DeepSeek 推理模型桌面客户端。Go 编写，内嵌 WebKit2GTK 网页视图，
支持原生窗口管理、文件对话框、剪贴板、拖放操作和 JavaScriptCore 桥接。
上游仓库：[esengine/DeepSeek-Reasonix](https://github.com/esengine/DeepSeek-Reasonix)。
发布版 tarball 通过 `fetchurl` 从 GitHub Releases 下载，使用
`autoPatchelfHook` 自动处理动态库链接。

## 使用方法

### 作为 flake 输入

在项目根 flake.nix 中添加入口：

```nix
{
  inputs.nixpkgs-nova.url = "github:raitpor/NovaNUR";

  outputs = { self, nixpkgs, nixpkgs-nova, ... }: {
    # ...
  };
}
```

之后可通过 `nixpkgs-nova.packages.${system}.reasonix-desktop` 访问。

### 在 home-manager 中使用

home-manager 作为 flake 模块时，在 `home.packages` 或 `programs` 中引用：

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs-nova.url = "github:raitpor/NovaNUR";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-nova, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      nova-pkgs = nixpkgs-nova.packages.${system};
    in
    {
      home-manager.users.raitpor = { pkgs, ... }: {
        home.packages = with pkgs; [
          nova-pkgs.reasonix-desktop
        ];
      };
    };
}
```

也可以走 `nixpkgs-nova.legacyPackages.${system}.reasonix-desktop`，效果相同。

### 非 flake 直引

NovaNUR 本地目录下直接 `callPackage`：

```nix
{ pkgs, ... }:
let
  reasonix-desktop = pkgs.callPackage ./pkgs/reasonix-desktop { };
in
{
  # 使用 reasonix-desktop
}
```

## 项目结构

```
NovaNUR/
├── flake.nix                 # flake 入口
├── default.nix               # NUR / 非 flake 兼容入口
├── pkgs/
│   └── reasonix-desktop/
│       └── default.nix       # 从 GitHub Releases 下载构建
└── README.md
```

维护：[raitpor](https://github.com/raitpor)
