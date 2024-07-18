package main

import "errors"

type intCalculator struct {
	num1 int
	num2 int
	op   operation
}

type operation byte

const (
	add operation = iota
	subtract
	multiply
	divide
)

func NewIntCalculator(num1, num2 int, op operation) *intCalculator {
	return &intCalculator{
		num1: num1,
		num2: num2,
		op:   op,
	}
}

// calculate performs the operation on the two numbers and returns the result
func (c *intCalculator) calculate() (int, error) {
	switch c.op {
	case add:
		return c.num1 + c.num2, nil
	case subtract:
		return c.num1 - c.num2, nil
	case multiply:
		return c.num1 * c.num2, nil
	case divide:
		if c.num2 == 0 {
			return 0, errors.New("division by zero")
		}
		return c.num1 / c.num2, nil
	default:
		return 0, errors.New("invalid operation")
	}
}
