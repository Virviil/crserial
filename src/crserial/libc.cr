module CrSerial
  ifdef linux
    O_NOCTTY = 0o00000400
    TCSANOW = 0
    TCSETS = 0x5402
    IGNPAR = 0o0000004
    VMIN = 6
    VTIME = 5
    CREAD = 0o0000200
    CLOCAL = 0o0004000
    NCCS = 19
  elsif darwin
    O_NOCTTY = 0x20000
    TCSANOW = 0
    IGNPAR = 0x00000004
    VMIN = 16
    VTIME = 17
    CLOCAL = 0x00008000
    CREAD = 0x00000800
    NCCS = 20
  end
  
  ifdef linux
    DATA_BITS = {
      5 => 0o0000000,
      6 => 0o0000020,
      7 => 0o0000040,
      8 => 0o0000060
    }
  elsif darwin
    DATA_BITS = {
      5 => 0x00000000,
      6 => 0x00000100,
      7 => 0x00000200,
      8 => 0x00000300
    }
  end
  
  ifdef linux
    BAUDE_RATES = {
      0       => 0o0000000,
      50      => 0o0000001,
      75      => 0o0000002,
      110     => 0o0000003,
      134     => 0o0000004,
      150     => 0o0000005,
      200     => 0o0000006,
      300     => 0o0000007,
      600     => 0o0000010,
      1200    => 0o0000011,
      1800    => 0o0000012,
      2400    => 0o0000013,
      4800    => 0o0000014,
      9600    => 0o0000015,
      19200   => 0o0000016,
      38400   => 0o0000017,
      57600   => 0o0010001,
      115200  => 0o0010002,
      230400  => 0o0010003,
      460800  => 0o0010004,
      500000  => 0o0010005,
      576000  => 0o0010006,
      921600  => 0o0010007,
      1000000 => 0o0010010,
      1152000 => 0o0010011,
      1500000 => 0o0010012,
      2000000 => 0o0010013,
      2500000 => 0o0010014,
      3000000 => 0o0010015,
      3500000 => 0o0010016,
      4000000 => 0o0010017
    }
  elsif darwin
    BAUDE_RATES = {
      0 => 0,
      50 => 50,
      75 => 75,
      110 => 110,
      134 => 134,
      150 => 150,
      200 => 200,
      300 => 300,
      600 => 600,
      1200 => 1200,
      1800 => 1800,
      2400 => 2400,
      4800 => 4800,
      9600 => 9600,
      19200 => 19200,
      38400 => 38400,
      7200 =>  7200,
      14400 => 14400,
      28800 => 28800,
      57600 => 57600,
      76800 => 76800,
      115200 => 115200,
      230400 => 230400
    }
  end
end

lib LibC
    ifdef linux
        struct Termios
            c_iflag : UInt
            c_oflag : UInt
            c_cflag : UInt
            c_lflag : UInt
            c_ispeed: UInt
            c_ospeed: UInt
            #TODO: Change UInt8 to UChar or Char after resolving issue https://github.com/manastech/crystal/issues/1937
            c_line  : UInt8
            cc_c    : UInt8[CrSerial::NCCS]
        end
    elsif darwin
        struct Termios
            c_iflag : ULong
            c_oflag : ULong
            c_cflag : ULong
            c_lflag : ULong
            c_ispeed: ULong
            c_ospeed: ULong
            #TODO: Change UInt8 to UChar or Char after resolving issue https://github.com/manastech/crystal/issues/1937
            c_line  : UInt8
            cc_c    : UInt8[NCCS]
        end
    end
    
    fun ioctl(fd: Int, cmd: ULong, io: Termios ) : Int
    fun tcsetattr(fildes: Int, optional_actions: Int, io: Termios ) : Int
end