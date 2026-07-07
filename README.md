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

定义 flake 后，在 NixOS 或 home-manager 配置中引用：

```nix
# flake.nix（使用者侧）
{
  inputs."NovaNUR".url = "github:raitpor/NovaNUR";

  outputs = { self, nixpkgs, ... }@inputs:
    let NovaNUR = inputs."NovaNUR"; in {
      # 使用 NovaNUR.packages.${system}.reasonix-desktop
    };
}
```

或者从项目根目录直接导入：

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
├── default.nix               # NUR 兼容入口
├── pkgs/
│   └── reasonix-desktop/
│       ├── default.nix       # 从 GitHub Releases 下载构建（hash 已填充）
│       └── reasonix-desktop  # 预编译二进制（本地缓存，可删除）
└── README.md
```

维护：[raitpor](https://github.com/raitpor)
