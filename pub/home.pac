// This is for non-browser apps such as Tweetbot which does not work well with
// Proxifier, applying this auto proxy config on global wi-fi setting is
// a workaround.
//
function FindProxyForURL(url, host)
{
    var hosts = new Array(
        // Twitter
        "*twitter*",
        "vine.co",
        "t.co",
        "*twimg.com",
        "img.ly",
        "*facebook*",

        // Google
        "*google*",
        "*gstatic.com*",
        "*youtube*",
        "goo.gl",
        "g.co",
        "g.cn",
        "*appspot.com",

        // Facebook
        "*instgram.com",
        "fb.me",
        "*dropbox.com",
        "bit.ly",
        "j.mp",
        "*akamaihd.com",

        // Amazon
        "*amazonaws.com",
        "gist.github.com",
        "*slack*",
        "*golang.org",
        "*godoc.org",

        // Others
        "*ytimg.com",
        "*mzstatic.com",
        "*apple-dns*,
        "bit.ly",
        "*dropbox.com"
    );

    var proxy = "SOCKS localhost:1080";

    for (var i = 0; i < hosts.length; i++) {
        if (shExpMatch(host, hosts[i])) {
            return proxy;
        }
    }
    return "DIRECT";
}
