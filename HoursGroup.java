/**
 * 
 */
package hours;

import java.awt.Font;
import java.util.Vector;

import javax.swing.JLabel;

/**
 * @author kbicknell
 * Represents a group of TrackerCategories
 */
public class HoursGroup {
  private String name;
  private Vector<HoursCategory> categories;
  public JLabel groupLabel;
  HoursGroupList groupList;
  private int index;          // index in the group list
  private int currentTaskCategory;
  
  /**
   * 
   */
  public HoursGroup(String name, int index, HoursGroupList groupList) {
    this.name = name;
    this.categories = new Vector<HoursCategory>();
    this.groupLabel = new JLabel();
    this.groupLabel.setText(name);
    this.groupLabel.setFont(new Font("Georgia", Font.PLAIN, 24));
    this.currentTaskCategory = -1;
    this.groupList = groupList;
    this.index = index;
  }

  public String name() {
    return(name);
  }
  
  public Vector<HoursCategory> categories() {
    return(categories);
  }
  
  public void addCategory(String name, int ms, long startTime) {
    categories.add(new HoursCategory(name, ms, startTime, categories.size(), this));
    if (startTime > 0) {
      currentTaskCategory = categories.size()-1;
    }
  }
  
  public void stopCurrentTask() {
    categories.get(currentTaskCategory).stop();
    currentTaskCategory = -1;
  }
  
  void setCurrentTaskCategory(int index) {
    currentTaskCategory = index;
    groupList.setCurrentTaskGroup(this.index);
  }
  
  public void switchAllToTextField() {
    for (HoursCategory c: categories) {
      c.switchToTextField();
    }
  }
  
  public void switchAllToLabel() {
    for (HoursCategory c: categories) {
      c.switchToLabel();
    }
  }
  
  public void clearAll() {
    for (HoursCategory c: categories) {
      c.clearAll();
    }
  }
}
