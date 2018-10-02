#ifndef INCLUDED_CRYPTOR_AES
#define INCLUDED_CRYPTOR_AES

#include <cryptor.h>

#include <iostream>
#include <iomanip>

#include <cryptopp/modes.h>
#include <cryptopp/aes.h>

namespace proxypp {
namespace crypto {

class CryptorAES : public Cryptor {
  public:
    CryptorAES(CryptoPP::byte*  key,
               size_t           keySize   = CryptoPP::AES::DEFAULT_KEYLENGTH,
               size_t           blockSize = CryptoPP::AES::BLOCKSIZE);
    virtual ~CryptorAES();

    virtual std::string encrypt(const unsigned char* in,
                                size_t               inSize);
    virtual std::string decrypt(const unsigned char* in,
                                size_t               inSize);

    CryptorAES(const CryptorAES&) = delete;
    CryptorAES& operator=(const CryptorAES&) = delete;
    CryptorAES(CryptorAES&&) = delete;
    CryptorAES& operator=(CryptorAES&&) = delete;
    CryptorAES() = delete;
  private:
    size_t                                        d_blockSize;
    CryptoPP::byte*                               d_iv;
    CryptoPP::AES::Encryption                     d_aesEncryptor;
    CryptoPP::AES::Decryption                     d_aesDecryptor;
    CryptoPP::CBC_Mode_ExternalCipher::Encryption d_cbcEncryption;
    CryptoPP::CBC_Mode_ExternalCipher::Decryption d_cbcDecryption;
};

}
}

#endif