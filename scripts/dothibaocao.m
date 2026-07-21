close all;
Plot_command = [1; 1; 1; 1; 1; 1];
%% Lấy dữ liệu vào cho FPID 
FPID_possition = struct2array(load("possition_FPID.mat"));
FPID_attitude = struct2array(load("attitude_FPID.mat")).Data';
FPID_saisovitri = struct2array(load("saisovitri_FPID.mat"));
FPID_saisogoc = struct2array(load("saisogoc_FPID.mat"));

%% Lấy dữ liệu vào cho PID 
PID_possition = struct2array(load("possition.mat"));
PID_attitude = struct2array(load("attitude.mat")).Data';
PID_saisovitri = struct2array(load("saisovitri.mat"));
PID_saisogoc = struct2array(load("saisogoc.mat"));

%% IF Pose Information (22:29) [8]
t = FPID_possition(1,:);
% Measured Pose from Optitrack  FPID
IF_Measured_x_FPID            = FPID_possition(3,:);
IF_Measured_y_FPID            = FPID_possition(5,:);
IF_Measured_z_FPID            = FPID_possition(7,:);

% Measured Pose from Optitrack PID 
IF_Measured_x_PID             = PID_possition(3,:);
IF_Measured_y_PID             = PID_possition(5,:);
IF_Measured_z_PID             = PID_possition(7,:);

% Switchbox Conditioned Pose Commands
IF_Desired_x                = FPID_possition(2,:);
IF_Desired_y                = FPID_possition(4,:);
IF_Desired_z                = FPID_possition(6,:);

% Attitide
phi_d                       = FPID_attitude(1,:);
theta_d                     = FPID_attitude(3,:);
psi_d                       = FPID_attitude(5,:);

phi_FPID                    = FPID_attitude(2,:);
theta_FPID                  = FPID_attitude(4,:);
psi_FPID                    = FPID_attitude(6,:);

phi_PID                     = PID_attitude(2,:);
theta_PID                   = PID_attitude(4,:);
psi_PID                     = PID_attitude(6,:);



%% Pose Plots

if Plot_command(1)
    figure; 
    subplot(3,1,1);
        hold on;
        plot(t, IF_Measured_x_FPID, 'r');
        plot(t, IF_Measured_x_PID, 'b');
        plot(t, IF_Desired_x, 'k-');
        hold off;
        ylabel('X (m)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID','PID','xd');
    subplot(3,1,2);
        hold on;
        plot(t, IF_Measured_y_FPID, 'r');
        plot(t, IF_Measured_y_PID, 'b');
        plot(t, IF_Desired_y, 'k-');
        hold off;
        ylabel('Y (m)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID','PID','yd');
    subplot(3,1,3);
        hold on;
        plot(t, IF_Measured_z_FPID, 'r');
        plot(t, IF_Measured_z_PID, 'b');
        plot(t, IF_Desired_z, 'k-');
        hold off;
        ylabel('Z (m)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID','PID','zd');
end

%% Pose Plots

if Plot_command(2)
    figure; 
    subplot(3,1,1);
        hold on;
        plot(t, phi_FPID.*180/pi, 'r');
        plot(t, phi_PID.*180/pi, 'b');
        plot(t, phi_d.*180/pi, 'k-');
        hold off;
        ylabel('Phi (deg)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID','PID','Roll_d');
    subplot(3,1,2);
        hold on;
        plot(t, theta_FPID.*180/pi, 'r');
        plot(t, theta_PID.*180/pi, 'b');
        plot(t, theta_d.*180/pi, 'k-');
        hold off;
        ylabel('Theta (deg)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID','PID','Pitch_d');
    subplot(3,1,3);
        hold on;
        plot(t, psi_FPID.*180/pi, 'r');
        plot(t, psi_PID.*180/pi, 'b');
        plot(t, psi_d.*180/pi, 'k-');
        hold off;
        ylabel('Psi (deg)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID','PID','Yaw_d');
end


%% Quadrotor flight trajectory
if Plot_command(3)
    figure;
    plot3 (IF_Measured_x_FPID, IF_Measured_y_FPID,IF_Measured_z_FPID, 'r');
    grid on; hold on;
    plot3 (IF_Measured_x_PID, IF_Measured_y_PID,IF_Measured_z_PID, 'b');
    plot3 ( IF_Desired_x, IF_Desired_y, IF_Desired_z, 'k-');
    xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
    title('Quy dao Quadrotor 3D'); 
    legend ('FPID','PID', 'Desired');
end
%% Sai so vi tri
if Plot_command(4)
    figure; 
    subplot(3,1,1);
        hold on;
        plot(t, IF_Measured_x_FPID -  IF_Desired_x, 'r','LineWidth', 1.2);
        plot(t, IF_Measured_x_PID -  IF_Desired_x, 'b','LineWidth', 1.2);
        hold off; 
        ylabel('e_x (m)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID', 'PID');
    subplot(3,1,2);
        hold on;
        plot(t, IF_Measured_y_FPID-IF_Desired_y, 'r', 'LineWidth', 1.2);
        plot(t, IF_Measured_y_PID-IF_Desired_y, 'b', 'LineWidth', 1.2);
        hold off; 
        ylabel('e_y (m)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID', 'PID');
    subplot(3,1,3);
        hold on;
        plot(t, IF_Measured_z_FPID-IF_Desired_z, 'r', 'LineWidth', 1.2);
        plot(t, IF_Measured_z_PID-IF_Desired_z, 'b', 'LineWidth', 1.2);
        hold off; 
        ylabel('e_z (m)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID', 'PID');
end
%% e Attitude
if Plot_command(5)
    figure; 
    subplot(3,1,1);
        hold on;
        plot(t, phi_d - phi_FPID, 'r','LineWidth', 1.2);
        plot(t, phi_d - phi_PID, 'b','LineWidth', 1.2);
        hold off; grid on;
        ylabel('e_phi (rad)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID', 'PID');
    subplot(3,1,2);
        hold on;
        plot(t, theta_d - theta_FPID, 'r','LineWidth', 1.2);
        plot(t, theta_d - theta_PID, 'b','LineWidth', 1.2);
        hold off;
        ylabel('e_theta (rad)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID', 'PID');
    subplot(3,1,3);
        hold on;
        plot(t, psi_d - psi_FPID, 'r','LineWidth', 1.2);
        plot(t, psi_d - psi_PID, 'b','LineWidth', 1.2);
        hold off;
        ylabel('e_psi (rad)');
        xlabel('time (s)');
        grid on; grid minor;
        legend('FPID', 'PID');
end
%%
if Plot_command(3)
    figure;
    plot3 ( IF_Desired_x, IF_Desired_y, IF_Desired_z, 'k-');
    xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
    title('Quy dao Quadrotor 3D'); 
    legend ( 'Desired');
end
