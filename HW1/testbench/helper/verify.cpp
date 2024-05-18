#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <cctype>
#include <locale>

#include "command.h"

using namespace std;

// trim from start (in place)
inline void ltrim(std::string &s, char delim = ' ')
{
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), [delim](unsigned char ch)
                                    { return ch != delim; }));
}

// trim from end (in place)
inline void rtrim(std::string &s)
{
    s.erase(std::find_if(s.rbegin(), s.rend(), [](unsigned char ch)
                         { return !std::isspace(ch); })
                .base(),
            s.end());
}

vector<vector<string>> read_csv(string filename, char delim = ',')
{
    ifstream file(filename);
    vector<vector<string>> res;
    string line;
    while (getline(file, line))
    {
        ltrim(line);
        rtrim(line);
        if (line.empty())
            continue;
        res.push_back(split(line, delim));
    }
    file.close();
    return res;
}

int main()
{
    initRegisters();
    vector<vector<string>> program = read_csv("../tb_CompALU.in", '_');
    vector<vector<string>> ans = read_csv("../tb_CompALU.out");
    for (int i = 0; i < program.size(); i++)
    {
        vector<string> line = program[i];
        vector<string> ans_line = ans[i];

        int type = cmd_type[line[0]];

        if (type == R_TYPE)
        {
            vector<uint32_t> resR = getRtypeValue(stoi(line[1], nullptr, 2), stoi(line[2], nullptr, 2), stoi(line[3], nullptr, 2), stoi(line[4], nullptr, 2));
            Result result = cmd_R[line[5]](resR);
            if (result.value != static_cast<uint32_t>(stoul(ans_line[1], nullptr, 2)) || result.zero != (ans_line[2] == "1") || result.carry != (ans_line[3] == "1"))
            {
                cout << "Error at line " << i + 1 << endl;
                cout << "Expected: " << hex << static_cast<uint32_t>(stoul(ans_line[1], nullptr, 2)) << " " << ans_line[2] << " " << ans_line[3] << endl;
                cout << "Got: " << hex << result.value << " " << result.zero << " " << result.carry << endl;
                cout << "Command: " << line[1] << " " << line[2] << " " << line[3] << " " << line[4] << " " << line[5] << endl;
                cout << "Registers: " << resR[0] << " " << resR[1] << " " << resR[2] << endl;
                return 1;
            }
        }
        else if (type == I_TYPE)
        {
        }
        else if (type == J_TYPE)
        {
        }
        else
        {
            cout << "WTF?" << endl;
            return 1;
        }
    }
    cout << "All tests passed" << endl;
    return 0;
}
