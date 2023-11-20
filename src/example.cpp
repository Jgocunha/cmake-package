#include "example.h"

#include <stdexcept>

Person::Person(std::string name, int age)
	:_name(std::move(name)), _age(age)
{
    if (_age < 0)
    {
        throw std::invalid_argument("Age needs to be a non-negative integer");
    }
}

std::string Person::getName() const
{
    return _name;
}

int Person::getAge() const
{
    return _age;
}