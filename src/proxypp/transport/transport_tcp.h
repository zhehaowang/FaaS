#ifndef INCLUDED_TRANSPORT_TCP
#define INCLUDED_TRANSPORT_TCP

#include <transport.h>

namespace proxypp {
namespace transport {

class TransportTCP : public Transport {
  public:
    virtual ~TransportTCP() = default;
  private:
};

}
}

#endif