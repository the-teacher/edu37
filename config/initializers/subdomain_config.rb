# # These are the sizes of the domain (i.e. 0 for localhost, 1 for something.com)  
# # for each of your environments
SubdomainFu.configure do |config|
  config.tld_size = 1
  config.tld_sizes = {:development => 1,  
                      :test => 1,
                      :production => 1
  }
  config.mirrors = ["www"]
end
