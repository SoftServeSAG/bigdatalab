#!/usr/bin/ruby
 
class IPGenerator
  public
  def initialize(session_count, session_length)
    @session_count = session_count
    @session_length = session_length
 
    @sessions = {}
  end
 
  public
  def get_ip
    session_gc
    session_create
 
    ip = @sessions.keys[Kernel.rand(@sessions.length)]
    @sessions[ip] += 1
    return ip
  end
 
  private
  def session_create
    while @sessions.length < @session_count
      @sessions[random_ip] = 0
    end
  end
 
  private
  def session_gc
    @sessions.each do |ip, count|
      @sessions.delete(ip) if count >= @session_length
    end
  end
 
  private
  def random_ip
    octets = []
    octets << Kernel.rand(223) + 1
    3.times { octets << Kernel.rand(255) }
 
    return octets.join(".")
  end
end
 
class LogGenerator
  EXTENSIONS = {
    'html' => 40,
    'php' => 30,
    'png' => 15,
    'gif' => 10,
    'css' => 5,
  }
 
  RESPONSE_CODES = {
    200 => 89,
    404 => 5,
    503 => 3,
    403 => 3
  }
 
  USER_AGENTS = {
    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)" => 19,
    "Mozilla/5.0 (X11; Linux i686) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.50 Safari/534.24" => 11,
    "Mozilla/5.0 (X11; Linux x86_64; rv:6.0a1) Gecko/20110421 Firefox/6.0a1" => 10,
	"amaya/9.52 libwww/5.4.0" => 1,
	"Debian APT-HTTP/1.3 (0.9.7.5ubuntu5.1)" => 2,
	"Ubuntu APT-HTTP/1.3" => 1,
	"gnome-vfs/2.12.0 neon/0.24.7" => 1,
	"Mozilla/4.08 (Charon; Inferno)" => 1,
	"Chimera/2.0alpha" => 1,
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.43 Safari/537.31" => 3,
	"Mozilla/5.0 (Windows NT 6.0; WOW64) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5" => 9,
	"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.52 Safari/536.5" => 7,
	"Contiki/1.0 (Commodore 64; http://dunkels.com/adam/contiki/)" => 1,
	"curl/7.19.5 (i586-pc-mingw32msvc) libcurl/7.19.5 OpenSSL/0.9.8l zlib/1.2.3" => 1,
	"Dillo/2.0" => 1,
	"DocZilla/1.0 (Windows; U; WinNT4.0; en-US; rv:1.0.0) Gecko/20020804" => 1,
	"ELinks (0.4.3; NetBSD 3.0.2_PATCH sparc64; 141x19)" => 1,
	"Emacs-W3/4.0pre.46 URL/p4.0pre.46 (i686-pc-linux; X11)" => 1,
	"fetch libfetch/2.0" => 1,
	"Mozilla/5.0 (X11; U; Linux armv61; en-US; rv:1.9.1b2pre) Gecko/20081015 Fennec/1.0a1" => 6,
	"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Firefox/24.0" => 3,
	"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:20.0) Gecko/20100101 Firefox/20.0" => 2,
	"Mozilla/5.0 (compatible; Konqueror/3.2; FreeBSD) (KHTML, like Gecko)" => 2,
	"Links (2.7; NetBSD 6.99.16 amd64; GNU C 4.7; x)" => 1,
	"Lynx/2.8.5dev.16 libwww-FM/2.14 SSL-MM/1.4.1 OpenSSL/0.9.6b" => 1,	
	"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; SV1; Maxthon; .NET CLR 1.1.4322)" => 2,
	"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; Xbox)" => 2,
	"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)" => 1,
	"Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:0.9.4.1) Gecko/20020508 Netscape6/6.2.3" => 1,
	"Opera/9.80 (J2ME/MIDP; Opera Mini/4.5.33867/32.855; U; en) Presto/2.8.119 Version/11.10" => 3,
	"Opera/9.00 (X11; Linux i686; U; en)" => 2,
	"Opera/8.00 (Windows NT 5.1; U; en)" => 1,
  }
  
  FILE_NAMES = {
    "index" => 41,
	"main" => 19,
	"picture" => 14,
	"dummy" => 6,
	"test" => 9,
	"list" => 11,
  }	
  
  PATH_NAMES = {
    "/var/www/mainpage/" => 30,
	"/var/www/cgi-bin/" => 5,
	"/var/www/basket/" => 6,
	"/var/www/checkout/" => 10,
	"/var/www/help/" => 3,
	"/var/www/sales/" => 7,
	"/var/www/hr/" => 9,
	"/var/www/delivery/" => 9,
	"/var/www/contacts/" => 10,
	"/var/www/careers/" => 13,
	"/var/www/about/" => 14,
  }	  

  HTTP_PROTOCOL = {
    "HTTP/1.1" => 81,
    "HTTP/1.0" => 13,
    "HTTP/1.2" => 6
  }

  OPERATIONS = {
    "GET" => 84,
    "PUT" => 16
  }

  REFERER = {
    "www.google.com" => 68,
    "www.ya.ru" => 2,
    "www.baidu.com" => 16,
    "www.bing.com" => 6,
    "www.yahoo.com" => 7,
    "www.ask.com" => 1
  }

 
  public
  def initialize(ipgen)
    @ipgen = ipgen
  end
 
  public
  def write_qps(dest, qps)
    sleep = 1.0 / qps
    rows_inc = 1
    rows_limit = ARGV[0].to_i
    while ((rows_inc <= rows_limit) or (rows_limit == 0)) do
      write(dest, 1)
      #sleep(sleep)
      rows_inc += 1
    end
  end
 
  public
  def write(dest, count)
    count.times do
      ip = @ipgen.get_ip
      path_name = pick_weighted_key(PATH_NAMES)
	    file_name = pick_weighted_key(FILE_NAMES)
      ext = pick_weighted_key(EXTENSIONS)
      resp_code = pick_weighted_key(RESPONSE_CODES)
      resp_size = Kernel.rand(2 * 1024) + 192;
      ua = pick_weighted_key(USER_AGENTS)
      http = pick_weighted_key(HTTP_PROTOCOL)
      date = Time.now.strftime("%d/%b/%Y:%H:%M:%S %z")
      operation = pick_weighted_key(OPERATIONS)
      request_time = Kernel.rand(1000 * 120) + 10;
      referer = pick_weighted_key(REFERER)
      dest.write("#{ip} - - [#{date}] \"#{operation} #{path_name}#{file_name}.#{ext} #{http}\" " +
                 "#{resp_code} #{resp_size} #{request_time} \"#{referer}\" \"#{ua}\"\n")
     end
  end
 
  private
  def pick_weighted_key(hash)
    total = 0
    hash.values.each { |t| total += t }
    random = Kernel.rand(total)
 
    running = 0
    hash.each do |key, weight|
      if random >= running and random < (running + weight)
        return key
      end
      running += weight
    end
 
    return hash.keys.first
  end
end
 
$stdout.sync = true
ipgen = IPGenerator.new(100, 10)
LogGenerator.new(ipgen).write_qps($stdout, 30)
