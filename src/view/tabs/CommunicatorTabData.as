/**
 * Created by kuts on 11/7/14.
 */
package view.tabs
{
import model.communicators.ICommunicator;

public class CommunicatorTabData
{
	private var _provider:ICommunicator;

	public function CommunicatorTabData(provider:ICommunicator)
	{
		_provider = provider;
	}

	public function get provider():ICommunicator
	{
		return _provider;
	}
}
}
