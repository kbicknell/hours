package hours;
import java.awt.Font;
import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

import com.apple.eawt.AppEvent;
import com.apple.eawt.Application;
import com.apple.eawt.QuitHandler;
import com.apple.eawt.QuitResponse;

import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.GroupLayout.ParallelGroup;
import javax.swing.GroupLayout.SequentialGroup;


public class Hours extends javax.swing.JFrame implements ActionListener {
  /**
   * 
   */
  private static final long serialVersionUID = 1L;
  private JButton stopButton;
  private JButton editButton;
  private JLabel dateLabel;
  private JLabel dayLabel;
  private Application macOSApplication;
  BufferedImage dockIcon;
  static final private String hoursFilename = ".hours";
  static final private String boundsFilename = ".hoursbounds";
  int x;
  int y;
  int width;
  int height;
  
  private GregorianCalendar calendar;
  
  private HoursGroupList groups;

	{
		//Set Look & Feel
		try {
			javax.swing.UIManager.setLookAndFeel("com.apple.laf.AquaLookAndFeel");
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
  /**
  * Auto-generated main method to display this JFrame
  */
  public static void main(String[] args) {
    SwingUtilities.invokeLater(new Runnable() {
      public void run() {
        Hours inst = new Hours();
        inst.setVisible(true);
      }
    });
  }
  
  public Hours() {
    super();
    macOSApplication = Application.getApplication();
    java.awt.Image iconAsImage = Toolkit.getDefaultToolkit().getImage("NSImage://clock2");
    dockIcon = (BufferedImage) iconAsImage;
    macOSApplication.setDockIconImage(dockIcon);
    
    macOSApplication.setQuitHandler(new QuitHandler() {
      public void handleQuitRequestWith(AppEvent.QuitEvent e, QuitResponse response) {
        updateBoundsFile(getBounds());
        response.performQuit();
      }
    });
    
    groups = new HoursGroupList(this);

    try {
      BufferedReader reader = new BufferedReader (new FileReader(hoursFilename));
      try {
        int year = Integer.parseInt(reader.readLine());
        int month = Integer.parseInt(reader.readLine());
        int day = Integer.parseInt(reader.readLine());
        calendar = new GregorianCalendar(year, month, day);
        reader.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    } catch (FileNotFoundException e) {
      calendar = new GregorianCalendar();
      updateHoursFile();
    }

    loadBounds();
    initGUI();
  }
  
  private void loadBounds() {
    
    try {
      BufferedReader reader = new BufferedReader (new FileReader(boundsFilename));
      try {
        x = Integer.parseInt(reader.readLine());
        y = Integer.parseInt(reader.readLine());
        width = Integer.parseInt(reader.readLine());
        height = Integer.parseInt(reader.readLine());
        setBounds(x,y,width,height);
        reader.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    } catch (FileNotFoundException e) {
      setBounds(100,100,300,800);
      updateBoundsFile(getBounds());
    }
  }
  
  private void updateBoundsFile(Rectangle bounds) {
    try {
      BufferedWriter writer = new BufferedWriter(new FileWriter(boundsFilename));
      writer.write(Integer.toString(bounds.x));
      writer.write("\n");
      writer.write(Integer.toString(bounds.y));
      writer.write("\n");
      writer.write(Integer.toString(bounds.width));
      writer.write("\n");
      writer.write(Integer.toString(bounds.height));
      writer.write("\n");
      writer.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
  
  void editButtonToEdit() {
    editButton.setActionCommand("edit");
  }
  
  void editButtonToStopEditing() {
    editButton.setActionCommand("stop editing");
  }
  
  void stopButtonToStop() {
    stopButton.setIcon(new ImageIcon(this.getClass().getResource("/resources/cancel.png")));
    stopButton.setActionCommand("stop");
  }

  void stopButtonToAdvance() {
    stopButton.setIcon(new ImageIcon(this.getClass().getResource("/resources/clock.png")));
    stopButton.setActionCommand("advance");
  }
  
  private void updateDateLabel() {
    SimpleDateFormat format = new SimpleDateFormat("d MMM");
    dateLabel.setText(format.format(calendar.getTime()));
    
    SimpleDateFormat format2 = new SimpleDateFormat("EEEE");
    dayLabel.setText(format2.format(calendar.getTime()));
  }
  
  private void updateHoursFile() {
    try {
      BufferedWriter writer = new BufferedWriter(new FileWriter(hoursFilename));
      writer.write(Integer.toString(calendar.get(Calendar.YEAR)));
      writer.write("\n");
      writer.write(Integer.toString(calendar.get(Calendar.MONTH)));
      writer.write("\n");
      writer.write(Integer.toString(calendar.get(Calendar.DATE)));
      writer.write("\n");
      writer.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
  
  private void initGUI() {
    try {
      GroupLayout thisLayout = new GroupLayout((JComponent)getContentPane());
      getContentPane().setLayout(thisLayout);
      thisLayout.setAutoCreateGaps(true);
      thisLayout.setAutoCreateContainerGaps(true);
      
      {
        stopButton = new JButton();
        if (groups.clockedIn()) {
          stopButtonToStop();
        } else {
          stopButtonToAdvance();
        }
        stopButton.addActionListener(this);        
      }
      {
        editButton = new JButton();
        editButton.setIcon(new ImageIcon(this.getClass().getResource("/resources/edit.png")));
        editButtonToEdit();
        editButton.addActionListener(this);
      }
      
      {
        dateLabel = new JLabel();
        dateLabel.setFont(new Font("Georgia", Font.PLAIN, 14));
        dayLabel = new JLabel();
        dayLabel.setFont(new Font("Georgia", Font.PLAIN, 18));
        updateDateLabel();
      }

      SequentialGroup headerGroupV = thisLayout.createSequentialGroup()
      .addGroup(
          thisLayout.createParallelGroup()
          .addGroup(
              thisLayout.createSequentialGroup()
              .addComponent(dayLabel)
              .addComponent(dateLabel)
          )
          .addComponent(stopButton)
          .addComponent(editButton)
          .addComponent(groups.totalTimeLabel)

      );


      ParallelGroup headerGroupH = thisLayout.createParallelGroup()
      .addGroup(
          thisLayout.createSequentialGroup()
          .addGroup(
              thisLayout.createParallelGroup()
              .addComponent(dayLabel)
              .addComponent(dateLabel)
          )
          .addComponent(stopButton)
          .addComponent(editButton)
          .addComponent(groups.totalTimeLabel)

      );
      
      // create vertical groupings
      SequentialGroup vGroup = thisLayout.createSequentialGroup();
      for (HoursGroup g: groups.groups()) {
        SequentialGroup groupGroupV = thisLayout.createSequentialGroup();
        groupGroupV.addGap(15);
        groupGroupV.addComponent(g.groupLabel);
        for (HoursCategory c: g.categories()) {
          ParallelGroup catGroupV = thisLayout.createParallelGroup()
            .addComponent(c.minLabel, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
            .addComponent(c.inButton).addComponent(c.catLabel);
          groupGroupV.addGroup(catGroupV);
        }
        vGroup.addGroup(groupGroupV);
      }
      
      // create horizontal groupings
      ParallelGroup hGroup = thisLayout.createParallelGroup();
      for (HoursGroup g: groups.groups()) {
        hGroup.addComponent(g.groupLabel);
      }
      
      SequentialGroup hGroupNotGroups = thisLayout.createSequentialGroup();
      hGroup.addGroup(hGroupNotGroups);
      
      ParallelGroup leftGroupGroupH = thisLayout.createParallelGroup();
      for (HoursGroup g: groups.groups()) {
        ParallelGroup leftGroupH = thisLayout.createParallelGroup();
        for (HoursCategory c: g.categories()) {
          leftGroupH.addComponent(c.minLabel, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE);
        }
        leftGroupGroupH.addGroup(leftGroupH);
      }
      hGroupNotGroups.addGroup(leftGroupGroupH);

      ParallelGroup rightGroupGroupH = thisLayout.createParallelGroup();
      for (HoursGroup g: groups.groups()) {
        ParallelGroup rightGroupH = thisLayout.createParallelGroup();
        for (HoursCategory c: g.categories()) {
          SequentialGroup rightCatGroupH = thisLayout.createSequentialGroup();
          rightCatGroupH.addComponent(c.inButton).addComponent(c.catLabel);
          rightGroupH.addGroup(rightCatGroupH);
        }
        rightGroupGroupH.addGroup(rightGroupH);
      }
      hGroupNotGroups.addGroup(rightGroupGroupH);

      thisLayout.setHorizontalGroup(
          thisLayout.createParallelGroup()
          .addGroup(
              thisLayout.createSequentialGroup()
              .addGroup(headerGroupH)
          )
          .addGroup(hGroup)
      );
      
      thisLayout.setVerticalGroup(
        thisLayout.createSequentialGroup()
          .addGroup(
              thisLayout.createParallelGroup()
                .addGroup(headerGroupV)
          )
          .addGroup(vGroup)
      );
      
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  
  
  public void actionPerformed(ActionEvent e) {
    if (e.getActionCommand().equals("stop")) {
      stopButtonToAdvance();
      groups.stopCurrentTask();
    } else if (e.getActionCommand().equals("advance")) {
      int response = JOptionPane.showOptionDialog(null, "Really advance date?", "Confirmation", JOptionPane.YES_NO_OPTION, JOptionPane.PLAIN_MESSAGE, null, null, null);
      if (response == JOptionPane.YES_OPTION) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy.MM.dd");
        String date = format.format(calendar.getTime());
        groups.writeData(date+".hdata", false);
        calendar.add(Calendar.DATE, 1);
        updateDateLabel();
        updateHoursFile();
        groups.clearAll();
      }
    } else if (e.getActionCommand().equals("edit")) {
      groups.switchAllToTextField();
      this.repaint();
      editButtonToStopEditing();
    } else if (e.getActionCommand().equals("stop editing")) {
      groups.switchAllToLabel();
      editButtonToEdit();
    }
  }
}
