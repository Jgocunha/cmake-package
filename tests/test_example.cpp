#include <catch2/catch_test_macros.hpp>

TEST_CASE("Application", "[Application]")
{
    SECTION("Application TO DO")
    {
        constexpr int a = 5 + 1;
        constexpr int b = 6;
        REQUIRE(a == b);
    }
}