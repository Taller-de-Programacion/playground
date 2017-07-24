#define _POSIX_C_SOURCE 200112L

#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <unistd.h>

#include <string.h>

int main(int argc, char *argv[]) {
    int ret = -1, s;
    int skt;

    const char* hostname = "www.google.com";
    const char* servicename = "https";

    struct addrinfo hints;
    struct addrinfo *result, *ptr;

    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_INET;       /* IPv4 (or AF_INET6 for IPv6)     */
    hints.ai_socktype = SOCK_STREAM; /* TCP  (or SOCK_DGRAM for UDP)    */
    hints.ai_flags = 0;              /* None (or AI_PASSIVE for server) */

    s = getaddrinfo(hostname, servicename, &hints, &result);
    if (s != 0)
        goto getaddrinfo_fail;

    for (ptr = result; ptr != NULL; ptr = ptr->ai_next) {
        skt = socket(ptr->ai_family, ptr->ai_socktype, ptr->ai_protocol);
        if (skt == -1)
            continue;   // ignore the error and keep trying
        
        s = connect(skt, ptr->ai_addr, ptr->ai_addrlen);
        if (s == -1) {
            close(skt);
            continue;   // ignore the error and keep trying
        }
     
        break;
    }

    freeaddrinfo(result);

    if (ptr == NULL) 
        goto didnt_connect;

    shutdown(skt, SHUT_RDWR);
    close(skt);

    ret = 0;

didnt_connect:
getaddrinfo_fail:
    return ret;
}

