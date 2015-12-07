import java.io.*;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.util.Scanner;
import java.util.Arrays;

public class Wrap {

  public int sqFeetRequired(int l, int w, int h) {
    return 2*l*w + 2*w*h + 2*h*l + smallestSideArea(l, w, h);
  }

  // shortest distance around its sides + cubic feed volume for bow
  public int ribbonRequired(int l, int w, int h) {
    int[] smallestSides = smallestSides(l, w, h);
    int distance = 2*smallestSides[0] + 2*smallestSides[1];
    return distance + l*w*h;
  }

  public int smallestSideArea(int l, int w, int h) {
    int[] smallestSides = smallestSides(l, w, h);
    return smallestSides[0] * smallestSides[1];
  }

  public int[] smallestSides(int l, int w, int h) {
    int[] sides = {l, w, h};
    Arrays.sort(sides);
    int[] smallest = {sides[0], sides[1]};
    return smallest;
  }

  public static void main(String[] args) {
    Wrap wrap = new Wrap();
    String input = null;
    try {
      input = new String(Files.readAllBytes(Paths.get("input")));
    } catch (IOException e) {
      e.printStackTrace();
    }
    Scanner scanner = new Scanner(input);
    int totalSqFt = 0;
    int totalRibbonReq = 0;
    while (scanner.hasNextLine()) {
      String line = scanner.nextLine();
      String parts[] = line.split("x");
      int l = Integer.parseInt(parts[0]);
      int w = Integer.parseInt(parts[1]);
      int h = Integer.parseInt(parts[2]);
      totalSqFt += wrap.sqFeetRequired(l, w, h);
      totalRibbonReq += wrap.ribbonRequired(l, w, h);
    }

    System.out.println("----- Part 1");
    System.out.println(String.format("Total Wrap Sq. Ft. Needed: %d", totalSqFt));
    System.out.println("----- Part 2");
    System.out.println(String.format("Total Ribbon length Needed: %d", totalRibbonReq));
    scanner.close();
  }
}
