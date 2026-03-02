conn ${tunnel_name}
    authby=secret
    auto=start
    left=%defaultroute
    leftid=${customer_gateway_ip}
    right=${vpn_gateway_ip}
    type=tunnel
    ikelifetime=8h
    keylife=1h
    phase2alg=aes128-sha1;modp2048
    ike=aes128-sha1;modp2048
    keyingtries=%forever
    keyexchange=ike
    leftsubnet=${customer_network}
    rightsubnet=${aws_network}
    dpddelay=10
    dpdtimeout=30
    dpdaction=restart_by_peer