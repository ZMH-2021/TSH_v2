#include "KVstoreClient.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <errno.h>

// 静态全局变量，仅在此文件中可见
static int client_socket = -1;

int kvstore_connect(const char *ip, const char *port) {
    // 如果已连接，先断开
    if (client_socket != -1) {
        fprintf(stderr, "Warning: Already connected, reconnecting...\n");
        close(client_socket);
    }

    // 创建socket
    client_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (client_socket == -1) {
        perror("socket() failed");
        return -1;
    }

    // 设置服务器地址
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(ip);
    server_addr.sin_port = htons(atoi(port));

    // 连接服务器
    if (connect(client_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("connect() failed");
        close(client_socket);
        client_socket = -1;
        return -1;
    }

    printf("Connected to server %s:%s\n", ip, port);
    return 0;
}

void kvstore_disconnect(void) {
    if (client_socket != -1) {
        close(client_socket);
        client_socket = -1;
        printf("Disconnected from server\n");
    }
}

int kvstore_send_command(const char *input, char *output) {
    if (client_socket == -1) {
        fprintf(stderr, "Error: Not connected to server\n");
        return -1;
    }

    // 发送命令
    ssize_t sent_bytes = send(client_socket, input, strlen(input), 0);
    if (sent_bytes == -1) {
        perror("send() failed");
        return -1;
    }

    // 接收响应
    ssize_t bytes_received = recv(client_socket, output, BUFFER_SIZE - 1, 0);
    if (bytes_received == -1) {
        perror("recv() failed");
        return -1;
    }

    output[bytes_received] = '\0'; // 确保字符串终止
    return 0;
}