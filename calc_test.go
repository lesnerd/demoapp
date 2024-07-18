package main

import (
	"testing"
)

func TestAddition(t *testing.T) {
	calculator := NewIntCalculator(5, 3, add)
	result, err := calculator.calculate()
	if err != nil {
		t.Errorf("Addition should not return an error")
	}
	if result != 8 {
		t.Errorf("Expected 5 + 3 to equal 8, got %d", result)
	}
}

func TestSubtraction(t *testing.T) {
	calculator := NewIntCalculator(5, 3, subtract)
	result, err := calculator.calculate()
	if err != nil {
		t.Errorf("Subtraction should not return an error")
	}
	if result != 2 {
		t.Errorf("Expected 5 - 3 to equal 2, got %d", result)
	}
}

func TestMultiplication(t *testing.T) {
	calculator := NewIntCalculator(5, 3, multiply)
	result, err := calculator.calculate()
	if err != nil {
		t.Errorf("Multiplication should not return an error")
	}
	if result != 15 {
		t.Errorf("Expected 5 * 3 to equal 15, got %d", result)
	}
}

func TestDivision(t *testing.T) {
	calculator := NewIntCalculator(6, 3, divide)
	result, err := calculator.calculate()
	if err != nil {
		t.Errorf("Division should not return an error")
	}
	if result != 2 {
		t.Errorf("Expected 6 / 3 to equal 2, got %d", result)
	}
}

func TestDivisionByZero(t *testing.T) {
	calculator := NewIntCalculator(5, 0, divide)
	_, err := calculator.calculate()
	if err == nil {
		t.Errorf("Division by zero should return an error")
	}
}

func TestInvalidOperation(t *testing.T) {
	calculator := NewIntCalculator(5, 3, 99) // Assuming 99 is an invalid operation
	_, err := calculator.calculate()
	if err == nil {
		t.Errorf("Invalid operation should return an error")
	}
}
