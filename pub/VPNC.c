/* VPNC.c */
#include <unistd.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    /* gcry_control from libgcrypt drops root euid privilege in vpnc.c */
    setuid(0);
    return execve("/usr/sbin/vpnc", argv, NULL);
}
