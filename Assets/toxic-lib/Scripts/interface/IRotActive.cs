public interface IRotActive
{
    void Active(float rot);
    void InoperAtive();
    bool GetActiveEnd();
    void SetSaveData(int rot);
    int GetSaveData();
}
