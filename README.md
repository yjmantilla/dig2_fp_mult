# fp_mult
floating point multiplier in vhdl
10 case of the MSB of the multiplication not accounted for. But it only checks the MSB bit so we are saved.

Exponent Sum with 8 bits can have overflow, solutions:
  - substract bias first or 
  - do the sum with 9 bits, it wont overflow in that case.
