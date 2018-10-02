#ifndef INCLUDED_TRANSPORT
#define INCLUDED_TRANSPORT

#include <functional>
#include <string>

namespace proxypp {
namespace transport {

class Transport {
  public:
    using OnConnected = std::function<void()>;
    using OnSendSuccess = std::function<void()>;
    using OnFailure = std::function<void(std::string)>;

    virtual ~Transport() = default;

    virtual void connect(const OnConnected& onConnected,
                         const OnFailure&   onFailure) = 0;
    virtual void send(const uint8_t*       data,
                      size_t               dataLen,
                      const OnSendSuccess& onSuccess,
                      const OnFailure&     onFailure) = 0;
};

}
}

#endif