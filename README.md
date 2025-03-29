# websitetoto

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