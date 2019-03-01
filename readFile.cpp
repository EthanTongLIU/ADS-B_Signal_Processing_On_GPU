#include <iostream>
#include <fstream>
#include <iomanip>
#include <cstdlib> // for exit()

using namespace std;

#define ADD_DATA_LENGTH 32768

const char* file = "TEST6ch.dat";

int main()
{
    unsigned char readUnit;

    ifstream fin;
    fin.open(file, ios::binary);

    if (fin.is_open())
    {
        int readedBytes = 0;
        cout << "以下是文件 " << file << " 的内容.\n\n";
        while (fin.read((char *) &readUnit, sizeof(readUnit)))
        {
            readedBytes += fin.gcount();
            // cout << (int)readUnit << " ";
            if (( readedBytes - 1 ) / ADD_DATA_LENGTH % 2 == 0)
            {
                switch (readedBytes % 4)
                {
                    case 1:
                        printf("channel 1: %x\n", readUnit);
                        // cout << "channel 1: " << (int)readUnit << "\n";
                        break;
                    case 2:
                        printf("channel 2: %x\n", readUnit);
                        // cout << "channel 2: " << (int)readUnit << "\n";
                        break;
                    case 3:
                        printf("channel 3: %x\n", readUnit);
                        // cout << "channel 3: " << (int)readUnit << "\n";
                        break;
                    case 0:
                        printf("channel 4: %x\n", readUnit);
                        // cout << "channel 4: " << (int)readUnit << "\n";
                        break;
                    default:
                        break;
                }
            }
            else
            {
                switch (readedBytes % 4)
                {
                    case 1:
                        printf("channel 5: %x\n", readUnit);
                        // cout << "channel 5: " << (int)readUnit << "\n";
                        break;
                    case 2:
                        printf("channel 6: %x\n", readUnit);
                        // cout << "channel 6: " << (int)readUnit << "\n";
                        break;
                    case 3:
                        printf("channel 7: %x\n", readUnit);
                        // cout << "channel 7: " << (int)readUnit << "\n";
                        break;
                    case 0:
                        printf("channel 8: %x\n", readUnit);
                        // cout << "channel 8: " << (int)readUnit << "\n";
                        break;
                    default:
                        break;
                }
            }

            if (readedBytes >= (ADD_DATA_LENGTH + 32))
            {
                break;
            }
        }
        cout << "\n\nreadUnit 类型占 " << sizeof(readUnit) << " Bytes\n";
        cout << "\n当前读取的字节数量为:" << readedBytes << "Bytes\n";
        fin.close();
    }
    cout << "读取结束.\n";
    return 0;
}

