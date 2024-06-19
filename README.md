# sync-image (Google Container Registry镜像加速)
-------

## Disclaimer/免责声明
-------
**本人郑重承诺**

1. **非盈利目的**  
   本项目不以盈利为目的，过去、现在、未来都不会用于牟利。

2. **可用性声明**  
   本项目不承诺永久可用（例如，GitHub 主动关闭本项目，GitHub Actions 免费计划修改，DockerHub 政策变化等）。尽管如此，本项目会尽量做到向后兼容，以确保在扩展 Registry 时不会影响现有的使用规则。

3. **镜像安全性声明**  
   本项目不承诺所转存的镜像是安全可靠的。本项目仅做转存操作（使用 skopeo 从上游 Registry 推送到目标 Registry）。在使用镜像前，请自行确认上游镜像来源的可靠性，务必自行避免供应链攻击。目前支持的 Registry 包括 `gcr.io`、`k8s.gcr.io`、`registry.k8s.io`、`quay.io`、`ghcr.io` 等，这些平台允许个人上传镜像，请谨慎使用。

4. **策略变更风险**  
   对于因 DockerHub 和 GitHub 的策略变更导致的不可预知且不可控的因素，例如业务无法拉取镜像而造成的任何损失，本项目不承担责任。

5. **上游镜像安全风险**  
   对于上游镜像中的恶意内容或者由于依赖库版本低导致的安全风险，本项目无法进行识别、删除、停用或过滤。用户在使用镜像时需要自行甄别和确认镜像的安全性，本项目对此不承担责任。


Syntax/语法
-------

```bash
# origin / 原镜像名称
gcr.io/namespace/{image}:{tag}
 
# eq / 等同于
registry.cn-hangzhou.aliyuncs.com/aliyun_ago/{image}:{tag}
```

## Uses/如何拉取新镜像
-------

[创建 Issues (直接套用模板即可)](https://github.com/im-jinxinwang/sync-image/issues/new/choose)，将自动触发 GitHub Actions 进行拉取并推送到阿里云容器镜像服务。

**注意：**

- 为了防止被滥用，目前仅支持一次同步一个镜像。
- Issues 必须带有 `porter` 标签，简单来说，通过 Sync Image 模板创建即可。
- 标题必须为 `镜像名:tag` 的格式，例如：
  - `quay.io/calico/apiserver:v3.28.0-28-g834d69939613`
- 默认同步所有平台。
- Issues 的内容无所谓，可以为空。
   - 可以参考 [已搬运镜像集锦](https://github.com/im-jinxinwang/sync-image/issues?q=is%3Aissue+label%3Aporter+)。

- 本项目目前仅支持 `mirror_rules.yaml` 文件中的镜像。对于其他镜像源，您可以提 Issues 反馈，或者自行 Fork 项目并修改 `mirror_rules.yaml`。

## 查询image tags
---

[创建 Issues (直接套用 List Image Tags 模板即可)](https://github.com/im-jinxinwang/sync-image/issues/new/choose)，将自动触发 GitHub Actions 获取 image tags。

## Fork/分叉代码自行维护
---
1. **必须**: [点击链接](https://github.com/im-jinxinwang/sync-image)，在您自己的账号下 Fork 出 `sync-image` 项目。
   
2. **可选**: 如果需要增加暂未支持的镜像库，请修改 [./mirror_rules.yaml](./mirror_rules.yaml) 文件。

3. **设置 GitHub Actions 权限**:
   在 [GitHub Actions 设置页面](../../settings/actions)，确保在 `Workflow permissions` 选项中为该项目授予读写权限。

4. **配置 Secrets**:
   在 [GitHub 项目 Secrets 设置页面](../../settings/secrets/actions) 创建以下自定义参数：

   - `DOCKER_REGISTRY`: 如果推送到 Docker Hub，请填写 `docker.io` 。
   - `DOCKER_NAMESPACE`: 如果推送到 Docker Hub，填写您的 Docker Hub 账号名（不带 @email 部分），例如 `usertest`。
   - `DOCKER_USER`: 如果推送到 Docker Hub，填写您的 Docker Hub 账号名（不带 @email 部分），例如 `usertest`。
   - `DOCKER_PASSWORD`: 如果推送到 Docker Hub，填写您的 Docker Hub 密码。


