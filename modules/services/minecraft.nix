{
  config,
  pkgs,
  lib,
  ...
}:

{
  networking.firewall.allowedUDPPorts = [
    24454
   ];
  # Minecraft server settings
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.main = {
      enable = true;
      autoStart = true;
      jvmOpts = "-Xms6G -Xmx10G";

      package = pkgs.fabricServers.fabric-26_1_2.override { jre_headless = pkgs.openjdk25_headless; };

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
                        Fabric-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/tnmuHGZA/fabric-api-0.146.1%2B26.1.2.jar";
              sha512 = "sha512-zYp2DsuXYScDb4BHwelo8mSuqc2d7KYObpy1dJaxtcynmHPFm3q0a5L0msIvSaK2lbtuvmFlPI32lU6XuINokA==";
            };
            Lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/R7MxYvuW/lithium-fabric-0.24.2%2Bmc26.1.2.jar";
              sha512 = "sha512-kjGtBWZ9Tu8DSMcAv1Fgkp4Lcj2eFF/ZfH/O+Th6wubVJPsV2Z9H+Pg48dI1Mk/XUM3LZgO2OqtghdefvqqzGw==";
            };
            Very-Many-Players = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/wnEe9KBa/versions/9f7J0dAp/vmp-fabric-mc26.1.2-0.2.0%2Bbeta.7.234-all.jar";
              sha512 = "sha512-JKDfJAeJOxz7VeJ9wcH+8AjfU1GNEYqjJFkk03tkKifXtq/elQ+/XQfEERxErCZNmuVrjYxqm1Ws37kboKFfFg==";
            };
            Concurrent-Chunk-Management-Engine = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/VSNURh3q/versions/lWpNUM5l/c2me-fabric-mc26.1.2-0.3.7%2Balpha.0.67.jar";
              sha512 = "sha512-x4T2imO+VDB3hLDV5atG0aePW1SD7oMgdliHTTCxfMcY4AQkU7Br+cWEFIz9A4LCDG1jPvPFhS7+B4QCsG5+tw==";
            };
            Servux = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/Cl7OXSCU/servux-fabric-26.1.1-0.10.1.jar";
              sha512 = "sha512-2GxzIGGHNvMCMI7JD+E6jtVbq4FbtTNVkcyLuvoJ9m/IoJBJ9pZAIr994TkSYufndYBYmbmdd76E07UkMgK+EQ==";
            };
            No-Chat-Reports = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/2yrLNE3S/NoChatReports-FABRIC-26.1-v2.19.0.jar";
              sha512 = "sha512-lNWKGkzeTjsXUL33JOZcX0/zQ2wlMvNqRl1JfSa/WfWsmWzdv/js3+13DDGaovLcycey0Zo1ZRwqdzXFshJNrQ==";
            };
            EasyAuth = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/aZj58GfX/versions/h9nSM2ZF/easyauth-mc26.1-3.4.3-SNAPSHOT.48.jar";
              sha512 = "sha512-CxqJKtQgNN6puSevnWxXPFN6/57j5tYFwbx1yicj9Q4NpoOChcaToGqyKbMzTaiVIUfz/zl7RnFAOKeWpbTQcw==";
            };
            Anti-Xray = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/sml2FMaA/versions/AK313N9m/antixray-fabric-1.4.16%2B26.1.jar";
              sha512 = "sha512-IT5l7gWEpmAhGPnm74Ydk/wJFgxbMrYn0pS5IKCNXPwlqDnyW/sqU73xreuNT9WMpnQ6PJk+h8+Ljis3G6Kp6w==";
            };
            Simple-Voice-Chat = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/eGxtLv6D/voicechat-fabric-2.6.16%2B26.1.2.jar";
              sha512 = "sha512-4yYe3fIKcJSQhsNH+VZxMH88WV4lZEekAiJ4Mga4mWJQ1vZrLFZ71WZm2HFiUztBkjfeR6NQIXbcKMrjYLxi+Q==";
            };
            Simple-Voice-Chat-Enhanced-Groups = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/1LE7mid6/versions/vLMugawx/enhancedgroups-fabric-1.7.1%2B26.1.2.jar";
              sha512 = "sha512-NGrR6u1h+4YXVee0iRQhnVvEAlxRQ4dUQ/B4OUmncWJBITkynSdK2INngm38A1XcqFSeJSQGEzGJQc5Ytqxqsw==";
            };
            AppleSkin = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/HwaLJe3v/appleskin-fabric-mc26.1-3.0.9.jar";
              sha512 = "sha512-eSk6DeWgD0YpbJS7HxxrHRPxsWx8y7Wv6MBH7bK8bRA0pDrxFnT2hro3BMfzjApOqSCQ7tZS+Kh6bmeQFNshlw==";
            };
            Universal-Graves = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/yn9u3ypm/versions/rZHOziFD/graves-3.11.0%2B26.1.2.jar";
              sha512 = "sha512-kd0KEtDUv2sFdDU5F01gQHpBcCbSXawvreEbqLpu/aHAleFUuyVTjpG7NjgeimDoxIAUTnQ0ijhWA6f6nMX9wg==";
            };
            Polymer = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/xGdtZczs/versions/Z1B30S8b/polymer-bundled-0.16.3%2B26.1.2.jar";
              sha512 = "sha512-k/WKDqcs3VqVuVk770V4HOerP2ev9ZKPLSFYG4cnOGLjMm8DZNk5EIzxv1K2BqdfjTAZ7TOSDsRLEfQQjZlrpw==";
            };
            Xaero's-World-Map = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/NcUtCpym/versions/xyGbYBF5/xaeroworldmap-fabric-26.1.2-1.40.14.jar";
              sha512 = "sha512-btWtzlvoUHXEF17lJXhP/dBXB009MiIuSd/HyujvlKBeX1TlFJdTOYrkKoBjyx+bIESUKvsIy+CP038sGOcucg==";
            };
            Xaero's-Mini-Map = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/1bokaNcj/versions/nhb2seHH/xaerominimap-fabric-26.1.2-25.3.11.jar";
              sha512 = "sha512-gjZ+7vKsE+wxO2xT1ltA17zCqbs/22KtqAQGhKHv/vc8lAZXwhRBCHj5nYuOUxcFvszF2QaqAHuDmyMej6wYuw==";
            };
            Terralith = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/8oi3bsk5/versions/FCzSjHeG/Terralith_26.1_v2.6.2_Fabric.jar";
              sha512 = "sha512-WjvimGpiREbIKoh5405Mewn2+YoZN/1Nm89TVrgyHwuc67XlZ+jQCugWHSYbEI+3yagOvtYfLtuM2whSszy6zA==";
            };
            Lithostitched = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/XaDC71GB/versions/cHH1mPJL/lithostitched-1.7.2-fabric-26.1.jar";
              sha512 = "sha512-Dgz7VfZGenrf+EdSbnbV2q8hLrN9KXMHv5fduhLCxiAvVyckht1VD2j/RN9lPCiNaXJMAeflXWlyPMhGuBNFAw==";
            };
            Tectonic = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/lWDHr9jE/versions/jL2ZsTzx/tectonic-3.0.22-fabric-26.1.jar";
              sha512 = "sha512-GHez55Vq9FJe64dYOScZ/qjGJLC4XDb9Pjd4CvSqWCOjvWmBzv/yc2TJmatJKrz+oCRIonpAS8QeO52SThvJcQ==";
            };
            CliffTree = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/59ypHk8x/versions/ccmOs0V8/CliffTree%203.2.1%20-%2026.1.jar";
              sha512 = "sha512-3upUQJ7bmIH9Um+0OenIKXKrOK4IZ/EJqTgr/1JIq6ITCi/w0jplQNr2b91JO6v25jNnbgBNIwWwdwbrkw9wMQ==";
            };
            Chunky = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/fALzjamp/versions/4Eotm6ov/Chunky-Fabric-1.5.3.jar";
              sha512 = "sha512-uDv+eyGNCqYjKvl3rnQdwfgrEOUM0Su3WfZc9Ba4tivsy1Q+WH7wuWcKvgOBVmD44JG8aCNiTWXPBzAFcVc1Fg==";
            };
          }
        );
      };
    };
  };
}
