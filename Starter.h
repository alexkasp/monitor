template <typename Daemon>
class DaemonStarter
{
	Daemon daemon_obj;
	DaemonStarter(){};
	//DaemonStarter& operator=(DaemonStarter){};
public:
	DaemonStarter(Daemon);
	virtual ~DaemonStarter();	
}