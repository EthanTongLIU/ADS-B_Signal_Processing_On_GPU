#include <iostream>
#include <fstream>
#include <iomanip>
#include <cstdlib> // for exit()

using namespace std;

// int oriCode2NegCode(int);

// // 函数功能：对负数将原码转换为补码
// int oriCode2NegCode(int originCode)
// {
//     int quotient = originCode / 2;
//     while (quotient != 0)
//     {

//         remainder = originCode%2;
//     }
// }

const char* file = "TEST6ch.dat";

int main()
{
    char readUnit;

    ifstream fin;
    fin.open(file, ios::binary);

    if (fin.is_open())
    {
        int readedBytes = 0;
        cout << "以下是文件 " << file << " 的内容.\n\n";
        while (fin.read((char *) &readUnit, sizeof(readUnit)))
        {
            readedBytes += fin.gcount();
            // 将负数都转换为补码
            if ((int)readUnit < 0)
            {
                readUnit = ~readUnit;
            }
            cout << (int)readUnit << ' '; // 输出每一个 readUnit 的 ASCII 码值
            if (readedBytes >= 1024)
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

