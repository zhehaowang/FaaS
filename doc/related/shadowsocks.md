# Shadowsocks protocol

### Overview

```
client --> ss-local (socks5 server) -- [encrypted | GFW | TCP / UDP] --> ss-remote --> target
```

### [socks5 (rfc1928)](https://tools.ietf.org/html/rfc1928)

A framework for client-server applications in TCP and UDP to securely use the services of a firewall.
Conceptually a shim layer between app-layer and transport-layer.

When a TCP-based client wishes to establish a connection to an object that is reachable only via a firewall, it must open a TCP connection to the appropriate SOCKS port (1080) on the SOCKS server system.

##### Authentication

If the connection request succeeds, the client enters an negotiation for the authentication method to be used, authenticates with the chosen method, then sends a relay request.
The SOCKS server evaluates the request and either establishes the appropriate connection or denies it.

```
Client ----- version / auth methods -----> Server:1080
Client <---- chosen auth method ---------- Server
Client --- method dependent negotiation -> Server
Client <-- method dependent negotiation -- Server
```
Auth methods: GSSAPI, pwd, IANA assigned, private methods, 0xFF no methods accepted, server rejects

##### Requests

Once auth succeeds, client then sends the request to connect / bind / associate to destination server : destination port.
```
Client -- connect / bind (tcp) / associate (udp) +
          dst v4/v6-IP:Port / domain name          --> Server:1080
Client <- status response, bond addr / port ---------- Server
```

Connect serves the regular TCP c/s workflow, bind is used in which client is required to accept connections from the server (e.g. FTP), and associate establishes an association within the UDP relay process to handle UDP datagrams.

If the server reply indicates a success, client can start sending data if the request is bind / connect.

A UDP-based client must send its datagrams to the UDP relay server at the UDP port indicated in the reply to the associate request.
Each datagram must contain a SOCKS-specific UDP request header.

### Circumvention

The encryption (and communication pattern) between ss client and server seem to be the reason why it's able to circumvent the GFW.
Refer to [high-level gfw techniques](ovpn_over_ss_setup.pdf) for details.

### References
* [Shadowsocks spec: protocol](http://shadowsocks.org/en/spec/Protocol.html), blocked
* [rfc1928](https://tools.ietf.org/html/rfc1928)
