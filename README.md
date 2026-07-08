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

### home-manager / NixOS（推荐 — overlay 方式）

NovaNUR 提供 `overlays.default`，注入到你自己的 `pkgs` 实例，
这样 `allowUnfree` 等配置就能直接透传：

```nix
# flake.nix（使用者）
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs-nova.url = "github:raitpor/NovaNUR";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-nova, ... }:
    let system = "x86_64-linux"; in {
      home-manager.users.raitpor = { pkgs, ... }: {
        nixpkgs.config.allowUnfree = true;        # 或用你的全局 allowUnfree
        nixpkgs.overlays = [ nixpkgs-nova.overlays.default ];

        home.packages = with pkgs; [
          reasonix-desktop                     # ← 直接当普通包用
        ];
      };
    };
}
```

### 独立构建

```bash
nix build 'github:raitpor/NovaNUR#reasonix-desktop'
NIXPKGS_ALLOW_UNFREE=1 nix run 'github:raitpor/NovaNUR#reasonix-desktop'
```

### 非 flake 直引

NovaNUR 本地目录下 `callPackage`：

```nix
pkgs.callPackage ./path/to/NovaNUR/pkgs/reasonix-desktop { }
```

## 项目结构

```
NovaNUR/
├── flake.nix                 # flake 入口
├── default.nix               # NUR / 非 flake 兼容入口
├── flake.nix                 # flake 入口
├── default.nix               # NUR / 非 flake 兼容入口
├── pkgs/
│   └── reasonix-desktop/
│       └── default.nix       # 从 GitHub Releases 下载构建
│       └── default.nix       # 从 GitHub Releases 下载构建
└── README.md
```

维护：[raitpor](https://github.com/raitpor)
