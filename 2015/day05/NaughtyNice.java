import java.io.*;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.util.Scanner;
import java.util.Arrays;

public class NaughtyNice {

  public boolean isNaughty(String input) {
    return true;
  }

  public static void part1() {
    String input = getInput();
    Scanner scanner = new Scanner(input);
    while (scanner.hasNextLine()) {
      String line = scanner.nextLine();
      char[]
    }
// Scanner scanner = new Scanner(input);
// while (scanner.hasNextLine()) {
//   String line = scanner.nextLine();
// }
  }

  public static void part2() {

  }

  public String getInput() {
    String input = null;
    try {
      input = new String(Files.readAllBytes(Paths.get("input")));
    } catch (IOException e) {
      e.printStackTrace();
    }
    return input;
  }

  public static void main(String[] args) {
    final long startTime = System.currentTimeMillis();
    System.out.println("----- Part 1");
    NaughtyNice.part1();
    System.out.println("----- Part 2");
    NaughtyNice.part2();
    final long endTime = System.currentTimeMillis();
    System.out.println("\tExecution Time: " + (endTime - startTime) + " ms");
  }
}
