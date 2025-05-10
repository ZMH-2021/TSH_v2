#ifndef KVSTORE_CLIENT_H
#define KVSTORE_CLIENT_H

#ifdef __cplusplus
extern "C" {
#endif

#define BUFFER_SIZE 512

// 连接KV存储服务器
// 参数: ip - 服务器IP, port - 服务器端口
// 返回: 成功返回0，失败返回-1
int kvstore_connect(const char *ip, const char *port);

// 断开连接
void kvstore_disconnect(void);

// 发送命令并接收响应
// 参数: input - 输入命令, output - 输出缓冲区(必须预分配至少BUFFER_SIZE空间)
// 返回: 成功返回0，失败返回-1
int kvstore_send_command(const char *input, char *output);

#ifdef __cplusplus
}
#endif

#endif // KVSTORE_CLIENT_H