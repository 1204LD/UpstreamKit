# UpstreamKit

一个 Windows GUI API 中转工具，用于配置上游模型接口、转发请求、记录日志和统计 token。

## 功能

- 输入上游 URL、Key、上游模型（实际请求）
- 上游类型可选 `openai` 或 `anthropic`
- 点击 `测试` 后会用当前 URL、Key、上游模型（实际请求）发一个最小请求
- 本地启动一个 `http://127.0.0.1:端口` 中转地址
- 客户端传来的 `key` 和 `model` 会被忽略，统一使用 GUI 里配置的上游 Key 和模型
- 日志区最多保留 1000 条，自动滚动并带时间戳
- 日志会自动换行，并打印请求编号、请求摘要、上游 URL、上游 HTTP 状态码、错误响应体预览、SSE 事件摘要和流式转发状态
- 流式响应结束时会明确关闭连接，避免客户端在上游已经结束后继续等待
- 点击窗口右上角关闭按钮后，程序会隐藏到系统托盘并继续后台运行；只有右键托盘图标点击 `退出` 才会真正停止端口并退出程序
- 会自动记住上次填写的 URL、Key、协议类型、模型和端口，下次启动自动恢复
- 会统计本次启动和历史总计 token，并保存到同目录 `token_stats.json`
- 如果上游 usage 能判断缓存命中，会显示 `输入（未命中）`、`输入（命中）`、`输出`；否则显示普通 `输入`、`输出`
- `/v1/messages/count_tokens` 会由本工具本地估算返回，避免上游兼容接口未实现该端点导致 Claude Code 失败

## 运行源码

```powershell
python api_relay_gui.py
```

## 配置保存位置

配置文件保存在程序同目录：

```text
config.json
```

启动时如果同目录没有 `config.json`，程序会自动创建一份默认配置。

token 统计文件也保存在程序同目录：

```text
token_stats.json
```

## 打包 exe

```powershell
.\build_exe.ps1
```

打包完成后文件在：

```text
dist\UpstreamKit.exe
```

## Claude Code 配置

1. 打开本工具，填写上游 URL、Key、上游模型（实际请求）。
2. 选择上游类型：
   - OpenAI 兼容接口：选 `openai`
   - Anthropic 兼容接口：选 `anthropic`
3. 可以先点击 `测试`，确认 URL、Key、模型可用。
4. 点击 `运行`。
5. 在 Claude Code 开发者模式里填写工具显示的本地 URL，例如：

```text
http://127.0.0.1:8787
```

Key 可以留空或随便填，模型名传来也会被本工具忽略。

## 说明

OpenAI 模式会把 Claude Code 常用的 Anthropic `/v1/messages` 请求转换为 OpenAI `/v1/chat/completions` 请求，并使用 GUI 里填写的上游模型（实际请求）。Anthropic 模式会透传 Anthropic 协议请求，只覆盖模型和鉴权。思考相关参数不由 GUI 干预，会跟随请求方原始参数。

## 思考相关字段

- `thinking（思考模式）`：Anthropic 协议字段，由请求方决定是否传给上游。
- `reasoning_effort（推理强度）`：OpenAI 兼容协议字段，由请求方决定是否传给上游。
- `reasoning_content（回传思考内容）`：OpenAI 兼容协议里的历史思考内容字段。OpenAI 模式下，中转会把 Claude/Anthropic 历史消息里的 `thinking` 内容转换成 `reasoning_content` 传给上游。
