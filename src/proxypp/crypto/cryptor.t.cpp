#include <cryptor_aes.h>
#include <gtest/gtest.h>

namespace proxypp {
namespace crypto {

TEST(AESCryptorEmptyKey, NormalOperation) {
    CryptoPP::byte key[CryptoPP::AES::DEFAULT_KEYLENGTH];
    memset(key, 0, CryptoPP::AES::DEFAULT_KEYLENGTH);
    CryptorAES aes(key);

    std::string plainText  = "good";
    std::string cipherText = aes.encrypt(reinterpret_cast<const unsigned char *>
                                             (plainText.c_str()),
                                         plainText.size());
    std::string decipheredText = aes.decrypt(reinterpret_cast<const unsigned char *>
                                                 (cipherText.c_str()),
                                             cipherText.size());
    EXPECT_EQ(plainText, decipheredText);

    std::string plainText2  = "bad";
    std::string cipherText2 = aes.encrypt(reinterpret_cast<const unsigned char *>
                                              (plainText2.c_str()),
                                          plainText2.size());
    std::string decipheredText2 = aes.decrypt(reinterpret_cast<const unsigned char *>
                                                  (cipherText2.c_str()),
                                              cipherText2.size());
    EXPECT_EQ(plainText2, decipheredText2);

    EXPECT_NE(plainText, decipheredText2);
    EXPECT_NE(plainText2, decipheredText);
}

TEST(AESCryptorSpecifiedKey, NormalOperation) {
    CryptoPP::byte key[CryptoPP::AES::DEFAULT_KEYLENGTH] = {
        0xdd, 0x60, 0x77, 0xec, 0xa9, 0x6b, 0x23, 0x1b,
        0x40, 0x6b, 0x5a, 0xf8, 0x7d, 0x3d, 0x55, 0x32
    };
    CryptorAES aes(key);

    std::string plainText  = "good";
    std::string cipherText = aes.encrypt(reinterpret_cast<const unsigned char *>
                                             (plainText.c_str()),
                                         plainText.size());
    std::string decipheredText = aes.decrypt(reinterpret_cast<const unsigned char *>
                                                 (cipherText.c_str()),
                                             cipherText.size());
    EXPECT_EQ(plainText, decipheredText);

    std::string plainText2  = "bad";
    std::string cipherText2 = aes.encrypt(reinterpret_cast<const unsigned char *>
                                              (plainText2.c_str()),
                                          plainText2.size());
    std::string decipheredText2 = aes.decrypt(reinterpret_cast<const unsigned char *>
                                                  (cipherText2.c_str()),
                                              cipherText2.size());
    EXPECT_EQ(plainText2, decipheredText2);

    EXPECT_NE(plainText, decipheredText2);
    EXPECT_NE(plainText2, decipheredText);
}

}
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
