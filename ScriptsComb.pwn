//by RogueDrifter @ 2017-12-12
// LINK TO POST: http://forum.sa-mp.com/showthread.php?t=646227
#define FILTERSCRIPT
#define CAMERA_MOVE_TIME 5000
#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#include <a_samp>
#include <zcmd>
#include <streamer>

new bool:LockStatus, bool:InRange[MAX_PLAYERS], bool:revenuerecorded[MAX_PLAYERS], bool:shootingrange,bool:callingtarget[3],bool:newbie[MAX_PLAYERS];
new PlayerText:CashShowingTextdraw[MAX_PLAYERS], RemoveTDrawTimer[MAX_PLAYERS];
new shootingrangeobjects[11],shootingrangepickup;

forward RecallTarget();
forward Spark(objectid);
forward CameraEnd(playerid);
forward RemoveTDraw(playerid);
forward ShowCashTDraw(playerid,amountcalled);
forward SparkCreate(playerid, Float:X, Float:Y, Float:Z, objectid);
forward EEI(playerid,InteriorID,Float:ix,Float:iy,Float:iz,Float:x,Float:y,Float:z,Float:rot,Interior,World,PerviousWorld);

public EEI(playerid,InteriorID,Float:ix,Float:iy,Float:iz,Float:x,Float:y,Float:z,Float:rot,Interior,World,PerviousWorld)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && IsPlayerInRangeOfPoint(playerid,3.0,ix,iy,iz) && GetPlayerVirtualWorld(playerid) == PerviousWorld && !LockStatus)
    {
        if(InteriorID == 1 && !shootingrange)
        {
            if(!InRange[playerid]) InRange[playerid]=true;
            else InRange[playerid]=false;
            SetPlayerPos(playerid,x,y,z);
            SetPlayerVirtualWorld(playerid,World);
            SetPlayerFacingAngle(playerid,rot);
            SetPlayerInterior(playerid,Interior);
            if(!newbie[playerid])
            {
                newbie[playerid] = true;
                SendClientMessage(playerid,-1,".: Welcome! If you don't see anymore targets please re-enter the shooting range. :.");
                }
            }
        }
    return 1;
}
public OnFilterScriptInit()
{
    shootingrangeobjects[1] = CreateDynamicObject(7586, -1894.14319, 439.09656, 40.55320,   0.00000, 0.00000, 0.00000,-1,-1,-1,300.0,300.0);
    shootingrangeobjects[2] = CreateDynamicObject(3524, -1894.29150, 439.26068, 48.19058,   0.00000, 0.00000, 0.00000,-1,-1,-1,300.0,300.0);
    //
    shootingrangeobjects[3] = CreateDynamicObject(3025, 277.37820, -139.13597, 1008.51520,   0.00000, 0.00000, 2.06732,-1,-1,-1,300.0,300.0);
    shootingrangeobjects[4] = CreateDynamicObject(1588, 277.66229, -139.13770, 1004.48389,   0.00000, 0.00000, 264.74747,-1,-1,-1,300.0,300.0);
    shootingrangeobjects[8] = CreateDynamicObject(1588, 277.66229, -139.13770, 1004.48389,   0.00000, 0.00000, 264.74747,-1,-1,-1,300.0,300.0);
    //
    shootingrangeobjects[7] = CreateDynamicObject(3025, 277.28601, -134.93350, 1008.50812,   0.00000, 0.00000, 2.06732,-1,-1,-1,300.0,300.0);
    shootingrangeobjects[0] = CreateDynamicObject(1588, 277.59030, -135.05881, 1004.48389,   0.00000, 0.00000, 268.82809,-1,-1,-1,300.0,300.0);
    shootingrangeobjects[9] = CreateDynamicObject(1588, 277.59030, -135.05881, 1004.48389,   0.00000, 0.00000, 268.82809,-1,-1,-1,300.0,300.0);
    //
    shootingrangeobjects[5] = CreateDynamicObject(3025, 277.09976, -130.44849, 1008.50812,   0.00000, 0.00000, 2.06732,-1,-1,-1,300.0,300.0);
    shootingrangeobjects[6] = CreateDynamicObject(1588, 277.35260, -130.32430, 1004.48389,   0.00000, 0.00000, 266.68640,-1,-1,-1,300.0,300.0);
    shootingrangeobjects[10] = CreateDynamicObject(1588, 277.35260, -130.32430, 1004.48389,   0.00000, 0.00000, 266.68640,-1,-1,-1,300.0,300.0);
    //
    shootingrangepickup = CreatePickup(1272, 1, -1894.1490,419.2843,35.1719, -1);
    CreatePickup(1272, 1, 299.9466,-142.0340,1004.0625, -1);
    return 1;
}
public ShowCashTDraw(playerid, amountcalled)
{
    new cashcountstring[56];
    if(!revenuerecorded[playerid])
    {
        if(amountcalled>0)
        {
            format(cashcountstring, sizeof(cashcountstring), "+$%i", amountcalled);
            GivePlayerMoney(playerid, amountcalled);
            }
        else
        {
            GivePlayerMoney(playerid, amountcalled);
            format(cashcountstring, sizeof(cashcountstring), "-$%i", amountcalled);
            }
        PlayerTextDrawShow(playerid,CashShowingTextdraw[playerid]);
        revenuerecorded[playerid]= true;
        PlayerTextDrawSetString(playerid,CashShowingTextdraw[playerid], cashcountstring);
        RemoveTDrawTimer[playerid] = SetTimerEx("RemoveTDraw", 2000, 0,"d",playerid);
        }
    else
    {
        if(amountcalled>0) GivePlayerMoney(playerid, amountcalled);
        if(amountcalled<0) GivePlayerMoney(playerid, amountcalled);
        }
    return 1;
}
public RemoveTDraw(playerid)
{
    revenuerecorded[playerid]=false;
    PlayerTextDrawSetString(playerid,CashShowingTextdraw[playerid], " ");
    PlayerTextDrawHide(playerid,CashShowingTextdraw[playerid]);
    return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_WALK))
    {
        EEI(playerid,1,-1894.1490,419.2843,35.1719,302.292877,-143.139099,1004.062500,0.0,7,71,0);
        EEI(playerid,1,299.9466,-142.0340,1004.0625,-1895.2998,415.9320,35.1719,177.1968,0,0,71);
        if(IsPlayerInRangeOfPoint(playerid,1.0,300.5052,-138.5757,1004.0625) && !callingtarget[0] )
        {
            callingtarget[0]=true;
            MoveDynamicObject(shootingrangeobjects[4] ,296.06030, -138.27589, 1004.48389, 5,    0.00000, 0.00000, 266.68640);
            MoveDynamicObject(shootingrangeobjects[3],295.69205, -138.36841, 1008.51520, 5,    0.00000, 0.00000, 0.00000);
            MoveDynamicObject(shootingrangeobjects[8] ,296.06030, -138.27589, 1004.48389, 5,    0.00000, 0.00000, 266.68640);
            SetTimer("RecallTarget",5000,false);
            }
        else if(IsPlayerInRangeOfPoint(playerid,1.0,300.6819,-135.5827,1004.0625) && !callingtarget[1]   )
        {
            callingtarget[1]=true;
            MoveDynamicObject(shootingrangeobjects[0] ,297.79120, -135.46260, 1004.48389, 5,    0.00000, 0.00000, 266.68640);
            MoveDynamicObject(shootingrangeobjects[7],297.53186, -135.58733, 1008.50812, 5,    0.00000, 0.00000, 0.00000);
            MoveDynamicObject(shootingrangeobjects[9] ,297.79120, -135.46260, 1004.48389, 5,    0.00000, 0.00000, 266.68640);
            SetTimer("RecallTarget",5000,false);
            }
        else if(IsPlayerInRangeOfPoint(playerid,1.0,300.5163,-131.0145,1004.0625) && !callingtarget[2]  )
        {
            callingtarget[2]=true;
            MoveDynamicObject(shootingrangeobjects[6] ,296.86371, -130.95380, 1004.48389, 5,    0.00000, 0.00000, 266.68640);
            MoveDynamicObject(shootingrangeobjects[5],296.59818, -131.05017, 1008.50812, 5,    0.00000, 0.00000, 0.00000);
            MoveDynamicObject(shootingrangeobjects[10] ,296.86371, -130.95380, 1004.48389, 5,    0.00000, 0.00000, 266.68640);
            }
        SetTimer("RecallTarget",5000,false);
        }
    return 1;
}
public RecallTarget()
{
        if(callingtarget[0])
        {
            callingtarget[0]=false;
            MoveDynamicObject(shootingrangeobjects[4] ,277.66229, -139.13770, 1004.48389, 8,    0.00000, 0.00000, 264.74747);
            MoveDynamicObject(shootingrangeobjects[3],277.37820, -139.13597, 1008.51520, 8,    0.00000, 0.00000, 0.00000);
            MoveDynamicObject(shootingrangeobjects[8] ,277.66229, -139.13770, 1004.48389, 8,    0.00000, 0.00000, 264.74747);
            }
        else if(callingtarget[1])
        {
            MoveDynamicObject(shootingrangeobjects[0] ,277.59030, -135.05881, 1004.48389, 8,    0.00000, 0.00000, 268.82809);
            MoveDynamicObject(shootingrangeobjects[7],277.28601, -134.93350, 1008.50812, 8,    0.00000, 0.00000, 0.00000);
            MoveDynamicObject(shootingrangeobjects[9] ,277.59030, -135.05881, 1004.48389, 8,    0.00000, 0.00000, 268.82809);
            callingtarget[1]=false;
            }
        else if(callingtarget[2])
        {
            callingtarget[2]=false;
            MoveDynamicObject(shootingrangeobjects[6] ,277.35260, -130.32430, 1004.48389, 8,    0.00000, 0.00000, 266.68640);
            MoveDynamicObject(shootingrangeobjects[5],277.09976, -130.44849, 1008.50812, 8,    0.00000, 0.00000, 0.00000);
            MoveDynamicObject(shootingrangeobjects[10] ,277.35260, -130.32430, 1004.48389, 8,    0.00000, 0.00000, 266.68640);
            }
        return 1;
}
//== The upcoming unique and amazing code belongs to @kadaradam LINK TO POST: http://forum.sa-mp.com/showthread.php?t=494085 ==//
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
        if(InRange[playerid])
        {
            SetPlayerArmedWeapon(playerid, 0);
            TogglePlayerControllable(playerid, 0);

            new
                Float:fOPos[3],
                Float:fHPos[3],
                Float:Angle,
                Float:Speed,
                object,
                time
            ;

            GetPlayerLastShotVectors(playerid, fOPos[0], fOPos[1], fOPos[2], fHPos[0], fHPos[1], fHPos[2]);
            GetPlayerFacingAngle(playerid, Angle);

            Speed = VectorSize(fOPos[0]-fHPos[0], fOPos[1]-fHPos[1], fOPos[2]-fHPos[2]) / ( CAMERA_MOVE_TIME / 1000 );

            object = CreatePlayerObject(playerid, 1636, fOPos[0], fOPos[1], fOPos[2], 0.0, 0.0, 0.0);
            SetObjectFacePoint(playerid, object, fHPos[0], fHPos[1]);
            MovePlayerObject(playerid, object, fHPos[0], fHPos[1], fHPos[2], Speed);

            SetTimerEx("CameraEnd", CAMERA_MOVE_TIME, false, "d", playerid);
            SetTimerEx("SparkCreate", CAMERA_MOVE_TIME-500, false, "ifffi",  playerid, fHPos[0], fHPos[1], fHPos[2], object);

            fHPos[0] -= (1 * floatsin(-Angle, degrees));
            fHPos[1] -= (1 * floatcos(-Angle, degrees));
            fOPos[0] += (1 * floatsin(-Angle, degrees));
            fOPos[1] += (1 * floatcos(-Angle, degrees));

            time = CAMERA_MOVE_TIME + floatround(CAMERA_MOVE_TIME * 0.15, floatround_round);

            InterpolateCameraPos(playerid, fOPos[0], fOPos[1], fOPos[2], fHPos[0], fHPos[1], fHPos[2], time, CAMERA_MOVE);
            }
        return 1;
}
public CameraEnd(playerid)
{
    SetPlayerArmedWeapon(playerid, 34);
    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);

}
public SparkCreate(playerid, Float:X, Float:Y, Float:Z, objectid)
{
    SetTimerEx("Spark", 100, false, "i", CreateObject(18717, X, Y, Z - 1.6, 0.0, 0.0, 0.0) );
    DestroyPlayerObject(playerid, objectid);
}
public Spark(objectid) DestroyObject(objectid);
//PLEASE PUT THIS UNDER OnPlayerDisconnect INCASE IF THE PLAYER DISCONNECTS INSIDE THE SHOOTING RANGE AND/OR DURING A CASH PROCESS
public OnPlayerDisconnect(playerid,reason)
{
    if(revenuerecorded[playerid])
    {
        KillTimer(RemoveTDrawTimer[playerid]);
        revenuerecorded[playerid]=false;
        PlayerTextDrawSetString(playerid,CashShowingTextdraw[playerid], " ");
        PlayerTextDrawHide(playerid,CashShowingTextdraw[playerid]);
        }
    if(InRange[playerid])
    {
        SpawnPlayer(playerid);//if your system saves position onplayerdisconnect and doesn't exclude interiors please keep this.
        SetPlayerInterior(playerid,0);//same as above for systems saving interior.
        SetPlayerVirtualWorld(playerid,0);//same as above for systems saving world.
        InRange[playerid]=false;
        }
    if(newbie[playerid]) newbie[playerid]=false;
    PlayerTextDrawDestroy(playerid, CashShowingTextdraw[playerid]);
    return 1;
}
public OnPlayerConnect(playerid)
{
    CashShowingTextdraw[playerid] = CreatePlayerTextDraw(playerid,514.800292, 68.293334, " ");
    PlayerTextDrawAlignment(playerid,CashShowingTextdraw[playerid],1);
    PlayerTextDrawBackgroundColor(playerid,CashShowingTextdraw[playerid],-216);
    PlayerTextDrawFont(playerid,CashShowingTextdraw[playerid],1);
    PlayerTextDrawLetterSize(playerid,CashShowingTextdraw[playerid],0.381599, 1.390933);
    PlayerTextDrawColor(playerid,CashShowingTextdraw[playerid],8388863);
    PlayerTextDrawSetOutline(playerid,CashShowingTextdraw[playerid],1);
    PlayerTextDrawSetProportional(playerid,CashShowingTextdraw[playerid],1);
    return 1;
}
CMD:lallinteriors(playerid,params[])
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,".: UNAUTHORIZED CMD :.");
    if(!LockStatus)
    {
        LockStatus =true;
        SendClientMessage(playerid,-1,".:Closed All Interiors!:.");
        }
    else
    {
        LockStatus =false;
        SendClientMessage(playerid,-1,".:Opened All Interiors!:.");
        }
    return 1;
}
CMD:bringtsrup(playerid,params[])
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,".: UNAUTHORIZED CMD :.");
    if(shootingrange)
    {
        shootingrange =false;
        SendClientMessage(playerid,-1,".: Opened!:.");
        shootingrangepickup = CreatePickup(1272, 1, -1894.1490,419.2843,35.1719, -1);
        MoveDynamicObject(shootingrangeobjects[1],-1894.14319, 439.09656, 40.55320, 5,    0.00000, 0.00000, 0.00000);
        MoveDynamicObject( shootingrangeobjects[2],-1894.29150, 439.26068, 48.19058, 5,    0.00000, 0.00000, 0.00000);
        }
    else SendClientMessage(playerid,-1,".:Already open!:.");
    return 1;
}
CMD:gotosr(playerid,params[])
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,".: UNAUTHORIZED CMD :.");
    ShowCashTDraw(playerid, -50);
    SendClientMessage(playerid,-1,".: Teleported to the shooting range!:.");
    GivePlayerWeapon(playerid,24,50);
    SetPlayerPos(playerid,-1894.1490,419.2843,35.1719);
    return 1;
}
CMD:bringtsrdown(playerid,params[])
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,".: UNAUTHORIZED CMD :.");
    if(!shootingrange)
    {
        shootingrange =true;
        SendClientMessage(playerid,-1,".: Closed!:.");
        DestroyPickup(shootingrangepickup);
        MoveDynamicObject( shootingrangeobjects[1],-1894.14319, 439.09656, 27.59607, 5,    0.00000, 0.00000, 0.00000);
        MoveDynamicObject( shootingrangeobjects[2],-1894.29150, 439.26068, 28.90132, 5,    0.00000, 0.00000, 0.00000);
        }
    else SendClientMessage(playerid,-1,".:Already closed!:.");
    return 1;
}

//== The great upcoming function is by Lorenc_ LINK TO POST: http://forum.sa-mp.com/showpost.php?p=1456045&postcount=2563 ==//
stock SetObjectFacePoint(playerid, objectid, Float: X, Float: Y)
{
    static
        Float: pX,      Float: oX,
        Float: pY,      Float: oY,
        Float: oZ
    ;
    GetPlayerObjectRot(playerid, objectid, oX, oY, oZ);
    GetPlayerObjectPos(playerid, objectid, pX, pY, oZ);
    oZ = ( floatadd(atan2(floatsub(Y, pY), floatsub(X, pX)), 270.0) );

    SetPlayerObjectRot(playerid, objectid, oX, oY, oZ);
}//Have fun.
