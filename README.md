# Web Site ToTo

## 迁移检查项目

- 网站页面是否能够正常打开
- 计划任务 Action 是配置
- Uamin 是否有数据
- 项目代码是否进行迁移
- Gitee 仓库是否添加
- 官网子页面是否添加
- 官网首页是否添加入口
- 页面打开是否有访问延迟的链接
- 其他问题


根据项目的管理方式和实际情况不同，不同的项目迁移方案不完全相同，大致出现如下几种方式

Hugo：基于golang的静态站点构建引擎
Gatsby: 基于React的静态站点构建引擎
Material-for-MkDocs：基于 Material 的 MkDocs 主题引擎
Gitbook: 基于 gitbook 的引擎
Jekyll : 基于 jekyll 的模板引擎
Rubybundle ：基于 ruby 的自定义渲染
Read-the-Docs: https://app.readthedocs.org/
未知 ： 未知




## 基于 github page

- [x]: kubevirt
- [x]: rook


## 基于 make 封装

- [x]: buildpacks
- [x]: cloud-custodian
- [x]: coressplane:,基于netlify_build脚本构建的文档
- [x]: keptn
- [x]: knatvie 基于脚本构建
- [x]: kubeedge
- [x] Thanos: make + hugo 构建
- [x]: Consul 基于 make + 容器镜像构建站点


## 基于 Hugo 

- [x]: cloudevents
- [x]: containerd
- [x]: coredns
- [x]: cni
- [x]: dapr
- [x]: emissary-ingress
- [x]: etcd
- [x]: falco
- [x]: fluxcd
- []: grafana: 镜像了特殊的封装，还未迁移成功
- [x]: grpc
- [x]: harbor
- [x]: helm
- [x]: in-toto
- [x]: istio
- [x]: jaeger
- [x]: keda
- [x]: kubeflow：文档在多层子目录中
- [x]: kubernetes
- [x]: kyverno
- [x]: letsencrypt
- [x]: linkerd
- [x]: longhorn
- [x]: notary
- [x]: openTelemetry: NPM+hugo
- []: spiffe：还没有构建成功
- [x]: tikv
- [x]: vitess
- [x]: volcano



## 基于 Docusaurus 构建的文档

- [x] BackStage: 基于 Yarn + docusaurus.config.ts 构建，多一层文档 microsite 目录
- [x] Chaosmesh: 基于 NPM + docusaurus.config.js
- [x] Dragonfly:  基于 Yarn + docusaurus.config.js
- [x] Karmada: 基于 NPM + docusaurus.config.js
- [x]: kubevela： 基于 Yarn + docusaurus.config.js
- [x]: litmuschaos: 基于 NPM + docusaurus.config.js
- [x]: openCost
- [x]: OpenFeature
- [x]: OpenKruise
- [x]: openYurt: 基于 NPM + docusaurus.config.js
- [] Podman:  基于 Yarn + docusaurus.config.js，网站构建好了，但是文档还没有
- [x]: wasmCloud 基于 Yarn + docusaurus.config.ts 构建，多一层文档 microsite 目录
- [] Calico: Makefile + Yarn + docusaurus.config.js


## 基于 Material for MkDocs

参考项目:  **ArgoCD**

注意事项：
- 构建是否有文档依赖，
- 是否通过 make 命令构建

涉及项目:
- [x] ArgoCD：基于mkdoc构建，有 get-deps 依赖
- [x] Rook
- [x] Loggie
- [x] Knative
- [x] Keptn
- [] Kubescape(todo): 没有文档相关的构建说明
- [] CloudCustodian(todo)：基于 sphinx 构建，相对不熟悉
- [x] Loggie


## 基于 Jekyll

- [] Cri-O


Jekyll : 基于 jekyll 的模板引擎



# 常见问题

## 默认输出路径

- hugo： `./app`



## Hugo 版本不匹配

**现象：**

- 缺少以来模板。如

```
ERROR render of "section" failed: "/home/runner/.cache/hugo_cache/modules/filecache/modules/pkg/mod/github.com/google/docsy@v0.6.0/layouts/_default/baseof.html:4:7": execute of template failed: template: adopters/list.html:4:7: executing "adopters/list.html" at <partial "head.html" .>: error calling partial: execute of template failed: html/template:partials/head.html:52:16: no such template "_internal/google_analytics_async.html"
```

**解决方案：**

一般情况下可以通过 `netlify.toml` 或 `Makefile` 文件查找 hugo 版本信息。
