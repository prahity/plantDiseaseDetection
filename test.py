import socket



def get_ip():

    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    try:

        # Send a dummy packet to get our IP address

        s.connect(('8.8.8.8', 80))

        ip = s.getsockname()[0]

    finally:

        s.close()

    return ip



if __name__ == "__main__":

    print("Your network IP address is:", get_ip())
