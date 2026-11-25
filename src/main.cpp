#include <iostream>
#include <string>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

using namespace std;

int parsePort(const string &port) {
    try {
        size_t used = 0;
        int requestedPort = stoi(port, &used);

        if (port.size() != used || (requestedPort < 1 || requestedPort > 65535)) {
            cerr << "Invalid port [" << port << "]. Try a port between 1-65535." << endl;
            return -1;
        }
        return requestedPort;
    }
    catch (const logic_error&) {
        cerr << "Invalid port" << endl;
        return -1;
    }
}

int main(int argc, char** argv) {
    
    int port = 8080;

    if (argc > 1) {
        string portString = argv[1];
        int parsedPort = parsePort(portString);
        if (parsedPort == -1) {
            return 1;
        }
        port = parsedPort;
    }

    cout << port << endl;

    return 0;
}