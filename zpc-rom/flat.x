OUTPUT_FORMAT("binary")
phys = 0;
SECTIONS
{
  .text phys : AT(phys) {
    code = .;
    *(.text)
    *(.rodata)
  }
  .data : AT(phys + (data - code))
  {
    data = .;
    *(.data)
  }
  .bss : AT(phys + (bss - code))
  {
    bss = .;
    *(.bss)
  }
  end = .;
}
