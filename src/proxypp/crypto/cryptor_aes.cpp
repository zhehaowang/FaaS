#include <cryptor_aes.h>

#include <cryptopp/filters.h>

namespace proxypp {
namespace crypto {

CryptorAES::CryptorAES(CryptoPP::byte* key,
                       size_t          keySize,
                       size_t          blockSize)
 : d_aesEncryptor(key, keySize),
   d_aesDecryptor(key, keySize),
   d_iv(new CryptoPP::byte[blockSize]()),
   d_cbcEncryption(d_aesEncryptor, d_iv),
   d_cbcDecryption(d_aesDecryptor, d_iv) {}

CryptorAES::~CryptorAES() {
    delete[] d_iv;
}

std::string CryptorAES::encrypt(const unsigned char* in,
                                size_t               inSize) {
    std::string cipherText;
    CryptoPP::StreamTransformationFilter stfEncryptor(d_cbcEncryption,
                                                      new CryptoPP::StringSink(cipherText));
    stfEncryptor.Put(in,
                     inSize);
    stfEncryptor.MessageEnd();
    return cipherText;
}

std::string CryptorAES::decrypt(const unsigned char* in,
                                size_t               inSize) {
    std::string plainText;
    CryptoPP::StreamTransformationFilter stfDecryptor(d_cbcDecryption,
                                                      new CryptoPP::StringSink(plainText));
    stfDecryptor.Put(in,
                     inSize);
    stfDecryptor.MessageEnd();
    return plainText;
}

}
}