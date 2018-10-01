#ifndef INCLUDED_CRYPTOR
#define INCLUDED_CRYPTOR

#include <string>

namespace proxypp {
namespace crypto {

class Cryptor {
  public:
    Cryptor() = default;
    virtual ~Cryptor() = default;

    Cryptor(const Cryptor&) = delete;
    Cryptor& operator=(const Cryptor&) = delete;
    Cryptor(Cryptor&&) = delete;
    Cryptor& operator=(Cryptor&&) = delete;

    virtual std::string encrypt(const unsigned char* in,
                                size_t               inSize) = 0;
    virtual std::string decrypt(const unsigned char* in,
                                size_t               inSize) = 0;
};

}
}

#endif