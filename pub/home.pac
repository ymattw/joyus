// Putty(plink) -D1080 corp-proxy
// Putty(plink)/iSSH -L1080:corp-socks:1080 corp-proxy
//
function FindProxyForURL(url, host)
{
    if (shExpMatch(url, "*yahoo*")) {
        return "SOCKS localhost:1080";
    } else {
        return "DIRECT";
    }
}
