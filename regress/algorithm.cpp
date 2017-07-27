#include <vector>
#include <algorithm>
#include <iostream>
#include <iomanip>

void print(const std::vector<int>& nums) {
    std::for_each(nums.begin(), nums.end(),
                 [](const int& i) { std::cout << std::setw(2) << i << ", "; });

    std::cout << std::endl;
}

void print_mark(const std::vector<int>& nums,
                const std::vector<int>::const_iterator& it) {


    std::for_each(nums.begin(), it,
                 [](const int& i) { std::cout << "    "; });

    std::cout << "^^  ";
    
    std::for_each(it + 1, nums.end(),
                 [](const int& i) { std::cout << "    "; });

    std::cout << std::endl;
}

int main(int argc, char* argv[]) {
    const int target_num = 25;
    std::vector<int> nums = {18, 19, 39, 21, 
                              2, 31, 23, 25, 
                             22,  5, 11,  6};

    std::cout << "Search for number '" << target_num << "':" << std::endl;
    print(nums);
    std::sort(nums.begin(), nums.end());
    print(nums);

    if (not std::binary_search(nums.begin(), nums.end(), target_num)) {
        std::cout << "Number '" << target_num << "' not found." << std::endl;
        return 1;
    }

    auto it = std::lower_bound(nums.begin(), nums.end(), target_num);
    print_mark(nums, it);

    return 0;
}
