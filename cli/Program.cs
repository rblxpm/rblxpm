using System;
using array;

namespace rblxpm
{
    class Program
    {
        
        public static string Version = "0.0.1";
        public static string ReleaseDate = "2021/06/21";

        static void Main(string[] args)
        {
            int c = 0;
            foreach (string i in args)
            {   
                c += 1;
                if(c > 0)
                {
                    if(c == 1) //command
                    {
                        if(!(i.StartsWith("--")))
                        {

                        }
                        else
                        {

                        }
                    }
                    else if(c > 2) //arguments
                    {
                        if(i.StartsWith("--"))
                        {
                            string a = i.Substring(2);
                            switch(a)
                            {
                                case "help":
                                    Console.WriteLine("help");
                                break;
                                case "version":
                                    Console.WriteLine($"Roblox Package Manager version {Version}. Released {ReleaseDate}.");
                                break;
                                default:
                                    Console.WriteLine($"Argument {a} not recognized. For a list of commands, type rblxpm --help.");
                                break;
                            }
                        }
                    }
                    else
                    {
                        Console.WriteLine("There was some sort of error that was uncalled for.");
                    }
                }
            }
        }
    }
}
