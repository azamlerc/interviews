import java.io.*;
import java.util.*;

class Solution {
  public static ArrayList<ArrayList<Integer>> makeMonth(int month, int year ) {
    ArrayList<ArrayList<Integer>> weeks = new ArrayList<>();
    
    Calendar calendar = Calendar.getInstance();
    calendar.set(Calendar.YEAR, year);
    calendar.set(Calendar.MONTH, month);
    calendar.set(Calendar.DATE, 0);
    java.util.Date last = calendar.getTime();
    calendar.set(Calendar.MONTH, month - 1);
    calendar.set(Calendar.DATE, 1);
    
    while (calendar.get(Calendar.DAY_OF_WEEK) > 1) {
      calendar.add(Calendar.DATE, -1);
    }
   
    while (calendar.getTime().compareTo(last) < 0) {
      ArrayList<Integer> week = new ArrayList<>();
      for (int i = 0; i < 7; i++) {
        week.add(calendar.get(Calendar.DAY_OF_MONTH));
        calendar.add(Calendar.DATE, 1);
      }
      weeks.add(week);
    }
    
    return weeks;
  }
  
  public static void main(String[] args) {
    ArrayList<ArrayList<Integer>> weeks = makeMonth(12, 2021);
    for (ArrayList<Integer> week : weeks) {
      System.out.println(week);  
    }
    
    if (makeMonth(2, 2015).size() == 4) {
      System.out.println("Feb 2015 has 4 weeks");
    }
    if (makeMonth(4, 2021).size() == 5) {
      System.out.println("Apr 2021 has 5 weeks");
    }
    if (makeMonth(5, 2021).size() == 6) {
      System.out.println("May 2021 has 6 weeks");
    }
  }
}
