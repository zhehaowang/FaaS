# Circumventing the GFW

### Tested working

##### openvpn over shadowsocks

* [openvpn setup]()
* [shadowsocks setup]()

##### Tor Browser

* [Tor with Meek]() (blocked)

### [Reported known techniques](https://en.wikipedia.org/wiki/Great_Firewall#Blocking_methods)

- IP blocking
- DNS spoofing (common ISP’s dns servers)
- http header url filtering (plaintext url inspection)
- tcp payload based filtering (plaintext payload inspection)
- man-in-the-middle (cnnic root cert is installed)
- tcp connection reset (firewall sends rst for 30 min if previously blocked)
- vpn detection (common port number, communication pattern)