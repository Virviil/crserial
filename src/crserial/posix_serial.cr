class Serial < IO::FileDescriptor
    
  def initialize(address, baude_rate=9600, data_bits=8)
    file_opts = LibC::O_RDWR | LibC::O_NOCTTY | LibC::O_NONBLOCK
    fd = LibC.open(address, file_opts)
    raise Errno.new("open") if @fd < 0

    fl = LibC.fcntl(@fd, LibC::FCNTL::F_GETFL, 0)
    raise Errno.new("fcntl") if fl < 0

    err = LibC.fcntl(@fd, LibC::FCNTL::F_SETFL, ~LibC::O_NONBLOCK & fl)
    raise Errno.new("fcntl") if err < 0

    config = build_config(baude_rate, data_bits)
    err = LibC.tcsetattr(@fd, LibC::TCSANOW, @config)
    raise Errno.new("tcsetattr") if err < 0
    
    super(fd)
  end
  
  def self.open(address, baude_rate=9600, data_bits=8)
    sp = Tempfile.new(address, baude_rate, data_bits)
    begin
      yield sp
    ensure
      sp.close
    end
    sp
  end

  private def build_config(baude_rate, data_bits)
    config = CrSerial::Termios.new

    config.c_iflag  = CrSerial::IGNPAR
    config.c_ispeed = CrSerial::BAUDE_RATES[baude_rate]
    config.c_ospeed = CrSerial::BAUDE_RATES[baude_rate]
    config.c_cflag  = CrSerial::DATA_BITS[data_bits] |
      CrSerial::CREAD |
      CrSerial::CLOCAL |
      CrSerial::BAUDE_RATES[baude_rate]

    config.cc_c[LibC::VMIN] = 0

    config
  end
end