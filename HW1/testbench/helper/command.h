#ifndef command_h
#define command_h

#include <vector>
#include <string>
#include <map>
#include <functional>
#include <cctype>
#include <sstream>

#define R_TYPE 0
#define I_TYPE 1
#define J_TYPE 2

using namespace std;

inline vector<string> split(const string &str, char delim)
{
    vector<string> res;
    stringstream ss(str);
    string token;
    while (getline(ss, token, delim))
    {
        res.push_back(token);
    }
    return res;
}

uint32_t registers[32];
void initRegisters()
{
    ifstream file("../RF.dat");
    for (int i = 0; i < 32; i++)
    {
        string tmp;
        file >> tmp;
        vector<string> tokens = split(tmp, '_');
        registers[i] = stoi(tokens[0], nullptr, 16);
        registers[i] = (registers[i] << 16) | stoi(tokens[1], nullptr, 16);
        // cout << hex << registers[i] << endl;
    }
}

class Result
{
public:
    uint32_t value;
    bool zero, carry;
};

Result addu(vector<uint32_t> &dataR)
{
    Result res;
    uint64_t tmp = static_cast<uint64_t>(dataR[0]) + dataR[1];
    res.value = tmp & 0xFFFFFFFF;
    res.zero = (res.value == 0);
    res.carry = tmp > 0xFFFFFFFF;
    return res;
}

Result subu(vector<uint32_t> &dataR)
{
    Result res;
    res.value = dataR[0] - dataR[1];
    res.zero = (res.value == 0);
    res.carry = dataR[0] < dataR[1];
    return res;
}

Result andu(vector<uint32_t> &dataR)
{
    Result res;
    res.value = dataR[0] & dataR[1];
    res.zero = (res.value == 0);
    res.carry = false;
    return res;
}

Result srl(vector<uint32_t> &dataR)
{
    Result res;
    res.value = dataR[0] >> dataR[2];
    res.zero = (res.value == 0);
    res.carry = false;
    return res;
}

vector<uint32_t> getRtypeValue(int rs, int rt, int rd, int shamt)
{
    uint32_t rs_val = registers[rs];
    uint32_t rt_val = registers[rt];
    return {rs_val, rt_val, static_cast<uint32_t>(shamt)};
}

vector<uint32_t> getItypeValue(int rs, int rt, int imm)
{
    uint32_t rs_val = registers[rs];
    return {rs_val, static_cast<uint32_t>(imm)};
}

vector<uint32_t> getJtypeValue(int target)
{
    return {static_cast<uint32_t>(target)};
}

// function map
map<string, function<Result(vector<uint32_t> &)>> cmd_R = {
    {"001001", addu},
    {"001010", subu},
    {"010001", andu},
    {"100010", srl}};

// type map
map<string, int> cmd_type = {
    {"000000", R_TYPE}};

#endif // command_h
